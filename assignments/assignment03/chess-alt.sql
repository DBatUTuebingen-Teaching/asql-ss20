-- King and Knight

\set board_width  8
\set board_height 8

DROP TABLE IF EXISTS board CASCADE;
DROP TABLE IF EXISTS piece_movements CASCADE;
DROP TABLE IF EXISTS movement CASCADE;

-- Create the movement table.
-- The values x_mov and y_mov represent the movement relative to the chess piece position.
-- E.g.: x_mov = -2 and y_mov = -1 means: The piece moves two left and one down.
CREATE TABLE movement (
  id    int PRIMARY KEY,
  x_mov int NOT NULL,
  y_mov int NOT NULL
);

-- Add various types of movement.
INSERT INTO movement VALUES
  ( 1,-2,-1), ( 2,-2, 1), ( 3, 2,-1), ( 4, 2, 1), ( 5,-1,-2), ( 6,-1, 2), ( 7, 1,-2), ( 8, 1, 2),
  ( 9, 1, 0), (10, 0, 1), (11, 1, 1), (12,-1, 0), (13, 0,-1), (14,-1,-1), (15, 1,-1), (16,-1, 1);

-- This table assigns each chess piece to its movement patterns.
CREATE TABLE piece_movements (
  piece_id char(1) NOT NULL,
  move_id  int     NOT NULL REFERENCES movement(id),
  PRIMARY KEY(piece_id, move_id)
);

-- Chess piece encoding:
-- White King   = k
-- Black King   = K
-- White Knight = n
-- Black Knight = N
INSERT INTO piece_movements VALUES
  ( 'n', 1), ( 'n', 2), ( 'n', 3), ( 'n', 4), ( 'n', 5), ( 'n', 6), ( 'n', 7), ( 'n', 8),
  ( 'N', 1), ( 'N', 2), ( 'N', 3), ( 'N', 4), ( 'N', 5), ( 'N', 6), ( 'N', 7), ( 'N', 8),
  ( 'k', 9), ( 'k',10), ( 'k',11), ( 'k',12), ( 'k',13), ( 'k',14), ( 'k',15), ( 'k',16),
  ( 'K', 9), ( 'K',10), ( 'K',11), ( 'K',12), ( 'K',13), ( 'K',14), ( 'K',15), ( 'K',16);

-- The chess board.
-- Even though the files are represented as characters from 'A' to 'H',
-- the table represents those with integers corresponding to said characters
-- starting with 1.
-- Therefore (1,1) represents (A,1), which is the square in the lower-left corner.
--
-- Example:
--    | A B C D E F G H
-- ---+------------------
--  8 |  | | | | | | |
--  7 |  | | | | | | |
--  6 |  | | | | | | |
--  5 |  |N| | | | | |
--  4 |  | | |n| | | |
--  3 |  | | | | | | |
--  2 |  | | | | | | |
--  1 |  | | | | | | |

CREATE TABLE board (
  x        int     NOT NULL,
  y        int     NOT NULL,
  piece_id char(1),
  selected boolean NOT NULL
  CONSTRAINT only_select_occupied_squares CHECK (selected = FALSE OR (selected = TRUE AND piece_id IS NOT NULL))
);

-- Fill chess board with empty unselected squares.
INSERT INTO board
SELECT x, y, NULL AS piece_id, false AS selected
FROM   generate_series (1,:board_width)  AS x,
       generate_series (1,:board_height) AS y;

-- As an example, we add chess pieces to the board and select some of them.
UPDATE board
SET    piece_id = 'n', 
       selected = true
WHERE  (x,y) = (4,4);
UPDATE board
SET    piece_id = 'N'
WHERE  (x,y) = (2,5);
UPDATE board
SET    piece_id = 'k'
WHERE  (x,y) = (4,1);
UPDATE board
SET    piece_id = 'K', 
       selected = true
WHERE  (x,y) = (6,7);

--
-- Example result:
--
--    | A B C D E F G H
-- ---+------------------
--  8 |  | | | |0|0|0|
--  7 |  | | | |0|K|0|
--  6 |  | |0| |0|0|0|
--  5 |  |N| | | |0| |
--  4 |  | | |n| | | |
--  3 |  |0| | | |0| |
--  2 |  | |0| |0| | |
--  1 |  | | |k| | | |
-- (8 rows)
--

-- List the board with its pieces.
-- Result:
-- x        : The x coordinate on the board.
-- y        : The y coordinate on the board.
-- piece_id : Is either the id of a positioned piece or NULL, if no piece is on that square.
-- piece    : The visual representation of either a piece or an empty square (' '). Type: CHAR(1).
WITH board_and_pieces (x,y,piece_id,piece) AS (
  -- a) YOUR QUERY HERE
),
-- List all squares the selected piece(s) can move to.
-- Result:
-- x        : The x coordinate on the board.
-- y        : The y coordinate on the board.
-- piece_id : Is either the id of a positioned piece or NULL, if no piece is on that square.
-- piece    : The visual representation of a space, where the selected piece can move to ('0'). Type: CHAR(1).
possible_movements (x,y,piece_id, piece) AS (
  -- b) YOUR QUERY HERE
),
-- Combine possible_mobements and the board_and_pieces to create the final result.
-- Result:
-- x        : The x coordinate on the board.
-- y        : The y coordinate on the board.
-- piece_id : Is either the id of a positioned piece or NULL, if no piece is on that square.
-- piece    : The visual representation of a piece, '0' or ' '. See board_and_pieces and possible_movements. Type: CHAR(1).
board_result (x,y,piece_id,piece) AS (
  SELECT pb.x AS x, pb.y AS y,
         string_to_array(STRING_AGG(pb.piece_id, ','), ',') AS piece_id, -- List all ids without NULL (ARRAY_AGG would list with NULLs).
         chr(CASE WHEN MAX(ascii(pb.piece)) = 0
             THEN 32
             ELSE MAX(ascii(pb.piece))
             END) AS piece -- Use MAX(...) because: ascii(' ') < ascii('0') < ascii(any chesspiece).
  FROM
  (
   SELECT *
   FROM possible_movements AS pom
     UNION
   SELECT *
   FROM board_and_pieces AS bap
  ) AS pb
  GROUP BY pb.y, pb.x
  ORDER BY pb.y DESC, pb.x
)
-- List in a chess board like fashion.
SELECT br.y AS " ", ARRAY_TO_STRING(ARRAY_AGG(br.piece ORDER BY br.x), '|') AS "A B C D E F G H "
  FROM board_result AS br
GROUP BY br.y
ORDER BY br.y DESC;
