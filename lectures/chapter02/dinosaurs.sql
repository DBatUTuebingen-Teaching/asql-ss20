-- Use case for SQL's common table expressions (WITH):
--
-- Infer bipedality (or quadropedality) for dinosaurs based
-- on their body length and shape.

DROP TABLE IF EXISTS dinosaurs;
CREATE TABLE dinosaurs (species text, height float, length float, legs int);

INSERT INTO dinosaurs(species, height, length, legs) VALUES
  ('Ceratosaurus',      4.0,   6.1,  2),
  ('Deinonychus',       1.5,   2.7,  2),
  ('Microvenator',      0.8,   1.2,  2),
  ('Plateosaurus',      2.1,   7.9,  2),
  ('Spinosaurus',       2.4,  12.2,  2),
  ('Tyrannosaurus',     7.0,  15.2,  2),
  ('Velociraptor',      0.6,   1.8,  2),
  ('Apatosaurus',       2.2,  22.9,  4),
  ('Brachiosaurus',     7.6,  30.5,  4),
  ('Diplodocus',        3.6,  27.1,  4),
  ('Supersaurus',      10.0,  30.5,  4),
  ('Albertosaurus',     4.6,   9.1,  NULL),  -- Bi-/quadropedality is
  ('Argentinosaurus',  10.7,  36.6,  NULL),  -- unknown for these species.
  ('Compsognathus',     0.6,   0.9,  NULL),  --
  ('Gallimimus',        2.4,   5.5,  NULL),  -- Try to infer pedality from
  ('Mamenchisaurus',    5.3,  21.0,  NULL),  -- their ratio of body height
  ('Oviraptor',         0.9,   1.5,  NULL),  -- to length.
  ('Ultrasaurus',       8.1,  30.5,  NULL);  --


-- ➊ Determine characteristic height/length (= body shape) ratio
-- separately for bipedal and quadropedal dinosaurs:
WITH bodies(legs, shape) AS (
  SELECT d.legs, avg(d.height / d.length) AS shape
  FROM   dinosaurs AS d
  WHERE  d.legs IS NOT NULL
  GROUP BY d.legs
)
-- ➋ Realize query plan (assumes table bodies exists)
SELECT d.species, d.height, d.length,
       (SELECT b.legs                               -- Find the shape entry in bodies
        FROM   bodies AS b                          -- that matches d's ratio of
        ORDER BY abs(b.shape - d.height / d.length) -- height to length the closest
        LIMIT 1) AS legs                            -- (pick row with minimal shape difference)
FROM  dinosaurs AS d
WHERE d.legs IS NULL
                      -- ↑ Locomotion of dinosaur d is unknown
  UNION ALL           ----------------------------------------
                      -- ↓ Locomotion of dinosaur d is known
SELECT d.*
FROM   dinosaurs AS d
WHERE  d.legs IS NOT NULL;





-----------------------------------------------------------------------
-- Equivalent formulation using DISTINCT ON (w/o LIMIT)

WITH bodies(legs, shape) AS (
  SELECT d.legs, avg(d.height / d.length) AS shape
  FROM   dinosaurs AS d
  WHERE  d.legs IS NOT NULL
  GROUP BY d.legs
)

SELECT d.*
FROM (SELECT DISTINCT ON (d.species) d.species, d.height, d.length, b.legs  -- ⎫  ORDER BY may not be
      FROM   dinosaurs AS d, bodies AS b                                    -- ⎬  top-level in a query
      WHERE  d.legs IS NULL                                                 -- ⎪  used in UNION
      ORDER BY d.species, abs(b.shape - d.height / d.length)) AS d          -- ⎭

  UNION ALL

SELECT d.*
FROM   dinosaurs d
WHERE  d.legs IS NOT NULL;
