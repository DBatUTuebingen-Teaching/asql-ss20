-- 1.

CREATE TABLE planes(
  plane     int PRIMARY KEY,
  allowance int NOT NULL
);

CREATE TABLE items(
  item   int PRIMARY KEY,
  weight int NOT NULL
);

INSERT INTO planes(plane, allowance) VALUES
  (1, 25000),
  (2, 19000),
  (3, 27000);

INSERT INTO items(item, weight) VALUES
  ( 1,  7120), ( 2,  8150),
  ( 3,  8255), ( 4,  9051),
  ( 5,  1220), ( 6, 12558),
  ( 7, 13555), ( 8,  5221),
  ( 9,   812), (10,  6562);

-------------------------------------------------------------------------------

-- 2.

CREATE TABLE heat (
  x int,  
  y int,  
  z float,         
  PRIMARY KEY (x,y)
);

INSERT INTO heat(x,y,z) VALUES
(0,0,10), (1,0, 0), (2,0, 0), (3,0, 0), (4,0, 0),
(0,1, 0), (1,1, 0), (2,1, 0), (3,1, 0), (4,1, 0),
(0,2, 0), (1,2, 0), (2,2, 0), (3,2, 0), (4,2, 0),
(0,3, 0), (1,3, 0), (2,3, 0), (3,3, 0), (4,3, 0),
(0,4, 0), (1,4, 0), (2,4, 0), (3,4, 0), (4,4, 0);

-------------------------------------------------------------------------------

-- 3.

