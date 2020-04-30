-- 1. 

-------------------------------------------------------------------------------

-- 2.

-- Q1
SELECT r.a, COUNT(*) AS c
FROM   R AS r
WHERE  r.b <> 3
GROUP BY r.a;

-- Q2
SELECT r.a, COUNT(*) AS c
FROM   R AS r 
GROUP BY r.a
HAVING EVERY(r.b <> 3);

-------------------------------------------------------------------------------

-- 3.

DROP TABLE IF EXISTS production_steps CASCADE;
CREATE TABLE production_steps (
  product_name    CHAR(20) NOT NULL,
  step            INTEGER  NOT NULL,
  completion_date DATE, -- NULL means incomplete
  PRIMARY KEY (product_name, step));

INSERT INTO production_steps VALUES
('TIE', 1, '1977/03/02'), ('AT-AT', 1, '1978/01/03' ), ('DS II', 1,  NULL       ),
('TIE', 2, '1977/12/29'), ('AT-AT', 2,  NULL        ), ('DS II', 2, '1979/05/26'),
                                                       ('DS II', 3, '1979/04/04');

-------------------------------------------------------------------------------

-- 4.

-- (a)
DROP TABLE IF EXISTS A CASCADE;
CREATE TABLE A (
  row int,
  col int,
  val int,
  PRIMARY KEY(row, col));

DROP TABLE IF EXISTS B CASCADE;
CREATE TABLE B ( LIKE A );

-- Example
INSERT INTO A (row,col,val)
VALUES (1,1,1), (1,2,2),
       (2,1,3), (2,2,4);


INSERT INTO B (row,col,val)
VALUES (1,1,1), (1,2,2), (1,3,1),
       (2,1,2), (2,2,1), (2,3,2);

-- (b)

TRUNCATE A;
TRUNCATE B;

INSERT INTO A (row,col,val)
VALUES (1,1,1), (1,2,3),
       (2,3,7);


INSERT INTO B (row,col,val)
VALUES (1,1,4),          (1,3,8 ),
       (2,1,1), (2,2,1), (2,3,10),
       (3,1,3), (3,2,6);
