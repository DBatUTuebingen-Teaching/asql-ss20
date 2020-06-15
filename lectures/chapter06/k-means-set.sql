-- A SQL implementation of the K-Means clustering algorithm (set semantics)
--
-- K-Means: https://en.wikipedia.org/wiki/K-means_clustering

-- Triggers bug in PostgreSQL 12.1 JIT compilation when TABLESAMPLE BERNOULLI(...) is used?
--  WARNING:  failed to resolve name float_overflow_error
--  WARNING:  failed to resolve name float_underflow_error
--  ERROR:  failed to look up symbol "evalexpr_2_0"
set jit = off;

-- ⚠ This variant implements K-Means using recursive UNION set semantics,
--   based on
--
--  ➊ a user-defined equality operator: = :: point × point → bool
--    (and aggregate AVG :: bag(point) → point)
\i points.sql

--  ➋ a custom integer type 'iter' (to count iterations) ALL OF
--     WHOSE VALUES COMPARE EQUAL and thus do not affect recursion
--     termination
\i iter.sql


-- Set of points P that we will cluster
DROP TABLE IF EXISTS points;
CREATE TABLE points (
  point  int   GENERATED ALWAYS AS IDENTIY,   -- unique point ID/label
  loc    point                                -- location of point in 2D space
);

-- Instantiate P
INSERT INTO points(loc) VALUES
   (point(1.0, 1.0)),
   (point(2.0, 1.5)),
   (point(4.0, 3.0)),
   (point(7.0, 5.0)),
   (point(5.0, 3.5)),
   (point(5.0, 4.5)),
   (point(4.5, 3.5));


-- K-Means using set semantics (UNION), this version finds the fixpoint
-- of the iterated K-Means computation and does not assume a predetermined
-- number of iterations.
--
-- NB.
--  - column "iter" is of user-definewd type iter (see 🠵 below ) whose
--    values always compare equal (and thus do not affect recursion termination)
--  - we rely on type point being comparable (required for set-based UNION)
--  - we make use of a user-defined AVG aggregate on type point (see 🠷 below)

WITH RECURSIVE
k_means(iter, point, cluster, mean) AS (
  SELECT 0 :: iter AS iter, p.point, ROW_NUMBER() OVER () AS cluster, p.loc AS mean
  --          🠵
  FROM   points AS p
  WHERE  p.point IN (5, 6)
    UNION
  SELECT (assign.iter + 1) :: iter AS iter, assign.point, assign.cluster,
  --      🠷                   🠵
         AVG(assign.loc) OVER cluster AS mean
  FROM   (SELECT DISTINCT ON (p.point) k.iter, p.point, k.cluster, p.loc
          FROM   points AS p, k_means AS k
          ORDER BY p.point, p.loc <-> k.mean) AS assign(iter, point, cluster, loc)
  WINDOW cluster AS (PARTITION BY assign.cluster)
)
TABLE k_means;
