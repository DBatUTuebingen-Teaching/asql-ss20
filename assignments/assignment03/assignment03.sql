-- 1. 

DROP TABLE t CASCADE;
DROP TABLE p CASCADE;
CREATE TABLE t (
  x int NOT NULL,
  y int NOT NULL
);

CREATE TABLE p (
  val int NOT NULL
);

INSERT INTO t VALUES
  (2,1),(5,3),(6,4),(7,6),(9,9);

INSERT INTO p VALUES
  (4),(5),(7),(8),(9);

-- 1)
SELECT t.x AS x
FROM   t AS t
WHERE  t.x IN
  (SELECT p.val
   FROM   p
   WHERE  p.val > 5);

-- 2)
SELECT t.x AS x
FROM   t AS t
WHERE  t.x IN
  (SELECT p.val
   FROM   p
   WHERE  p.val > t.y);

-------------------------------------------------------------------------------

-- 2.