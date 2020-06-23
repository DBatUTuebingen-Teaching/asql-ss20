-- 1.

CREATE TABLE trees (
  tree    int PRIMARY KEY,
  parents int[],
  labels  text[]
);

WITH RECURSIVE
paths(tree, pos, node) AS (
  SELECT t.tree, 0 AS pos, array_position(t.labels, 'f') AS node
  FROM   trees AS t
    UNION
  SELECT t.tree, p.pos + 1 AS pos, t.parents[p.node] AS node
  FROM   paths AS p, trees AS t
  WHERE  p.tree = t.tree AND p.node IS NOT NULL
  -- avoid infinite recursion once we reach the root
)
SELECT p.tree, p.pos, p.node
FROM   paths AS p
WHERE  p.node IS NOT NULL
ORDER BY p.tree, p.pos;

-------------------------------------------------------------------------------

-- 2.

DROP FUNCTION fib(numeric);
CREATE FUNCTION fib(n numeric) 
RETURNS TABLE(i numeric, "fib(i)" numeric) AS $$
  -- Your (recursive) CTE here
$$ LANGUAGE SQL;

-------------------------------------------------------------------------------

-- 3.