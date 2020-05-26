-- 1. 

CREATE TABLE s (
  arr_id integer PRIMARY KEY,
  arr    text[]);

INSERT INTO s VALUES
(1, ARRAY['a','b','c','b']),
(2, ARRAY['e','f','e']);

CREATE TABLE t (
  arr_id integer,
  idx    integer,
  val    text,
  PRIMARY KEY(arr_id, idx));

INSERT INTO t VALUES
(1,1,'a'),(1,2,'b'),(1,3,'c'),(1,4,'b'),
(2,1,'e'),(2,2,'f'),(2,3,'e');

-- a)
SELECT s.arr[1] AS val
FROM   s AS s
WHERE  s.arr_id = 1;

-- b)
SELECT array_length(s.arr,1) AS len
FROM   s AS s
WHERE  s.arr_id = 1;

-- c)
SELECT a AS val
FROM   s             AS s,
       unnest(s.arr) AS a
WHERE  s.arr_id = 2;

-- d)
SELECT array_position(s.arr, 'b')
FROM   s AS s
WHERE  s.arr_id = 1;

-- e)
TABLE s
  UNION ALL
SELECT r.id + 1         AS arr_id, 
       s.arr||'g'::text AS arr
FROM s AS s, (
  SELECT MAX(s.arr_id)
  FROM   s AS s
) AS r(id)
WHERE s.arr_id = 1;

-------------------------------------------------------------------------------

-- 2.

CREATE TABLE matrices (
  matrix text[][] NOT NULL
);

INSERT INTO matrices VALUES
(array[['1','2','3'],
       ['4','5','6']]),
(array[['f','e','d'],
       ['c','b','a']]);

-------------------------------------------------------------------------------

-- 3.

CREATE TABLE trees (
  tree    int PRIMARY KEY,
  parents int[],
  labels  numeric[]
);

INSERT INTO trees VALUES
(1, ARRAY[NULL,1,2,2,1,5], 
    ARRAY[3.3,1.5,5.0,1.5,1.5,1.5]),
(2, ARRAY[3,3,NULL,3,2], 
    ARRAY[0.4,0.4,0.2,0.1,7.0]);
