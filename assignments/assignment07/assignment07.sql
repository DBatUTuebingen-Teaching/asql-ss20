-- 1.

-------------------------------------------------------------------------------

-- 2.

DROP TABLE IF EXISTS seesaw CASCADE;
CREATE TABLE seesaw (
  pos    int GENERATED ALWAYS AS IDENTITY,
  weight int NOT NULL
);

INSERT INTO seesaw(weight) (
  SELECT floor(random()*10) AS weight
  FROM   generate_series(1,100) AS _
);

-------------------------------------------------------------------------------

-- 3.

DROP TABLE IF EXISTS measurements CASCADE;
CREATE TABLE measurements (
  ts  timestamp PRIMARY KEY,
  val numeric
);

INSERT INTO measurements VALUES
  ('2019-12-04 07:34:59', NULL),
  ('2019-12-04 07:37:16', 42.0),
  ('2019-12-04 07:38:36',  4.1),
  ('2019-12-04 07:42:33', NULL),
  ('2019-12-04 07:55:06', NULL),
  ('2019-12-04 07:57:06', 12.3),
  ('2019-12-04 08:03:18', NULL),
  ('2019-12-04 08:15:44', 15.1),
  ('2019-12-04 08:22:21',  2.2),
  ('2019-12-04 08:37:31', NULL);
