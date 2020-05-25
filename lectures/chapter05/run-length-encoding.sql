-- Run-length encoding (compression) of pixel images

-- Sample input image
--
DROP TABLE IF EXISTS input;
CREATE TEMPORARY TABLE input (
  y      serial,
  pixels text NOT NULL
);

\COPY input(pixels) FROM stdin
░▉▉░░░▉▉░░░▉░░░
▉░░▉░▉░░▉░░▉░░░
▉░░░░▉░░▉░░▉░░░
░▉▉░░▉░░▉░░▉░░░
░░░▉░▉░▉▉░░▉░░░
▉░░▉░▉░░▉░░▉░░░
░▉▉░░░▉▉░▉░▉▉▉▉
\.

TABLE input;

-- (x,y,color) representation of image to encode
--
DROP TYPE IF EXISTS color CASCADE;
CREATE TYPE color AS ENUM ('undefined', '░', '▉');

DROP TABLE IF EXISTS original;
CREATE TABLE original (
  x     int   NOT NULL,
  y     int   NOT NULL,
  pixel color NOT NULL,
  PRIMARY KEY (x,y)
);

-- Load image from sample input
INSERT INTO original(x,y,pixel)
  SELECT col.x, row.y, col.pixel :: color
  FROM   input AS row,
         LATERAL unnest(string_to_array(row.pixels, NULL)) WITH ORDINALITY AS col(pixel,x);


-----------------------------------------------------------------------
-- Run-length encoding

WITH
changes(x,y,pixel,"change?") AS (
  SELECT o.x, o.y, o.pixel,
         o.pixel <> LAG(o.pixel, 1, 'undefined') OVER byrow AS "change?"
  FROM   original AS o
  WINDOW byrow AS (ORDER BY o.y, o.x)
                -- ──────────────
                -- scans image row-by-row
),
runs(x,y,pixel,run) AS (
  SELECT c.x, c.y, c.pixel,
         SUM(c."change?" :: int) OVER byrow AS run
         --  ───────────────
         --  true → 1, false → 0
  FROM   changes AS c
  WINDOW byrow AS (ORDER BY c.y, c.x) -- default: RANGE FROM UNBOUNDED PRECEDING TO CURRENT ROW ⇒ SUM scan
),
encoding(run,length,pixel) AS (
  SELECT r.run, COUNT(*) AS length, r.pixel
  FROM   runs AS r
  GROUP BY r.run, r.pixel
               -- ────
               -- does not affect grouping since run → pixel (all pixels in a run have the same color)
  ORDER BY r.run
)
TABLE encoding;

-----------------------------------------------------------------------
-- Decoding ...

-- ... can be done easily (see a future assignment)
