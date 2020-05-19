-- 1. 

SELECT p.a, p.b * 2, p.c, p.d, p.e, p.f
FROM   (VALUES 
  (1,'2'::money,4   ,41+1::real,1::real,NULL),
  (2,'5.72'    ,1.32,2         ,2      ,NULL),
  (3,'2'::money,5.77,3         ,3      ,NULL)
) AS p(a,b,c,d,e,f)
WHERE  p.c < 5.5;

SELECT p.a, p.b * 2, p.c, p.d, p.e, p.f
FROM   p AS p
WHERE  p.c < 5.5;

-------------------------------------------------------------------------------

-- 2.

CREATE TABLE allcards_json (
  data json
);

\copy allcards_json FROM 'path/to/AllCards.json/here';

DROP TABLE mtj CASCADE;
CREATE TABLE mtj (
  name      text PRIMARY KEY,
  mana_cost text,
  cmc       numeric,
  type      text,
  text      text,
  power     text,
  toughness text
);


