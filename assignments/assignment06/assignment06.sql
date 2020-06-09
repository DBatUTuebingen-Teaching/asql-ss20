-- 1.

CREATE TABLE arrays (
  id  int GENERATED ALWAYS AS IDENTITY,
  arr int[] CHECK (cardinality(arr) > 0)
);

INSERT INTO arrays(arr) VALUES
  (ARRAY[1,2,3,5,6]),
  (ARRAY[4,3]),
  (ARRAY[7,6,9]),
  (ARRAY[2,2]);

-------------------------------------------------------------------------------

-- 2.

CREATE TABLE mountains (
  y int  GENERATED ALWAYS AS IDENTITY,
  m text 
);

INSERT INTO mountains(m) VALUES
  (' #  '),
  ('### '),
  ('####');

-------------------------------------------------------------------------------

-- 3.

-- Define result as type alias for numeric(3,1).
CREATE DOMAIN result AS numeric(3,1);

CREATE TABLE analysis (
  dataset char(1) NOT NULL,
  x       numeric NOT NULL,
  y       numeric NOT NULL
);

\copy analysis FROM '/path/to/data.csv' WITH (FORMAT csv, HEADER TRUE);

-------------------------------------------------------------------------------

-- 4.