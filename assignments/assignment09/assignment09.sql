-- 1.

DROP TABLE IF EXISTS roads CASCADE;
CREATE TABLE roads (
  here  text,
  dist  int,
  there text,
  PRIMARY KEY(here, there)
);

INSERT INTO roads VALUES
  ('A'  , 20 , 'B'), ('A'  , 42 , 'C'),
  ('A'  , 35 , 'D'), ('B'  , 20 , 'A'),
  ('B'  , 30 , 'C'), ('B'  , 34 , 'D'),
  ('C'  , 42 , 'A'), ('C'  , 30 , 'B'),
  ('C'  , 12 , 'D'), ('D'  , 35 , 'A'),
  ('D'  , 34 , 'B'), ('D'  , 12 , 'C');

-------------------------------------------------------------------------------

-- 2.

DROP TABLE IF EXISTS room;
DROP TYPE IF EXISTS direction;

CREATE TYPE direction AS ENUM ('N','S','W','E');

CREATE TABLE room (
  x   int       NOT NULL,
  y   int       NOT NULL,
  dir direction NOT NULL,
  PRIMARY KEY (x,y));

-- Example room and stormtrooper patrol
\set width  4
\set height 4
INSERT INTO room(x,y,dir) VALUES
  (1, 1, 'E'), (3, 1, 'S'),
  (4, 1, 'S'), (2, 3, 'S'),
  (3, 3, 'W'), (2, 4, 'E');

-------------------------------------------------------------------------------

-- 3.

DROP TABLE IF EXISTS log;
CREATE TABLE log (
  hour         int,       
  userid       int,
  "logged in?" boolean);

INSERT INTO log VALUES
(1,1,FALSE), (1,2,FALSE),
(2,1,TRUE ), (2,2,FALSE),
(3,1,TRUE ), (3,2,TRUE ),
(4,1,TRUE ), (4,2,TRUE ),
(5,1,FALSE), (5,2,TRUE ),
(6,1,TRUE ), (6,2,FALSE);