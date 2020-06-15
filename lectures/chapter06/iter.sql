-- User-defined type iter which
--  - acts like (4-byte) integers when it comes to arithmetics
--  - DEFINES ALL OF ITS VALUES TO BE EQUAL ⚠️
--
-- Thus:

/*
SELECT 42 :: iter = 41 :: iter;

SELECT 42 :: iter < 41 :: iter;

SELECT DISTINCT t.x
FROM   (VALUES (1::iter),(2::iter),(3::iter)) AS t(x);

SELECT DISTINCT *
FROM   (VALUES (1, 0 :: iter), (1, 1 :: iter)) AS t(x,d);

SELECT t1.x
FROM   (VALUES (1::iter),(2::iter),(3::iter)) AS t1(x)
  UNION
SELECT t2.x
FROM   (VALUES (4::iter),(5::iter),(6::iter)) AS t2(x);


WITH RECURSIVE
test(a,b,d) AS (
  SELECT 5, 4, 0 :: iter
    UNION
  SELECT t.b, t.b - gs, (t.d + 1) :: iter
  FROM (TABLE test) AS t, generate_series(1,2) AS gs
  WHERE t.b > 0
)
TABLE test;
*/


DROP TYPE IF EXISTS iter CASCADE;
CREATE TYPE iter;

CREATE FUNCTION iter_in(s cstring) RETURNS iter
LANGUAGE internal IMMUTABLE AS 'int4in';
CREATE FUNCTION iter_out(d iter) RETURNS cstring
LANGUAGE internal IMMUTABLE AS 'int4out';

CREATE TYPE iter (
  INPUT  = iter_in,
  OUTPUT = iter_out,
  LIKE   = integer
);

-- ⚠️
CREATE FUNCTION iter_eq(iter, iter) RETURNS boolean AS
$$
  SELECT true;
$$  LANGUAGE SQL IMMUTABLE STRICT;

-- ⚠️
CREATE FUNCTION iter_ne(iter, iter) RETURNS boolean AS
$$
  SELECT false;
$$  LANGUAGE SQL IMMUTABLE STRICT;

CREATE FUNCTION iter_lt(iter, iter)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4lt';

CREATE FUNCTION iter_le(iter, iter)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4le';

CREATE FUNCTION iter_gt(iter, iter)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4gt';

CREATE FUNCTION iter_ge(iter, iter)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4ge';

-- ⚠️
CREATE FUNCTION iter_cmp(iter, iter) RETURNS integer AS
$$
  SELECT 0;
$$ LANGUAGE SQL IMMUTABLE STRICT;

-- ⚠️
CREATE FUNCTION hash_iter(iter) RETURNS integer AS
$$
  SELECT 0;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OPERATOR = (
  LEFTARG = iter,
  RIGHTARG = iter,
  PROCEDURE = iter_eq,
  COMMUTATOR = '=',
  NEGATOR = '<>',
  RESTRICT = eqsel,
  JOIN = eqjoinsel,
  HASHES, MERGES
);

CREATE OPERATOR <> (
  LEFTARG = iter,
  RIGHTARG = iter,
  PROCEDURE = iter_ne,
  COMMUTATOR = '<>',
  NEGATOR = '=',
  RESTRICT = neqsel,
  JOIN = neqjoinsel
);

CREATE OPERATOR < (
  LEFTARG = iter,
  RIGHTARG = iter,
  PROCEDURE = iter_lt,
  COMMUTATOR = > ,
  NEGATOR = >= ,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);

CREATE OPERATOR <= (
  LEFTARG = iter,
  RIGHTARG = iter,
  PROCEDURE = iter_le,
  COMMUTATOR = >= ,
  NEGATOR = > ,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);

CREATE OPERATOR > (
  LEFTARG = iter,
  RIGHTARG = iter,
  PROCEDURE = iter_gt,
  COMMUTATOR = < ,
  NEGATOR = <= ,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);

CREATE OPERATOR >= (
  LEFTARG = iter,
  RIGHTARG = iter,
  PROCEDURE = iter_ge,
  COMMUTATOR = <= ,
  NEGATOR = < ,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);

CREATE OPERATOR CLASS btree_iter_ops
DEFAULT FOR TYPE iter USING btree
AS
        OPERATOR        1       <  ,
        OPERATOR        2       <= ,
        OPERATOR        3       =  ,
        OPERATOR        4       >= ,
        OPERATOR        5       >  ,
        FUNCTION        1       iter_cmp(iter, iter);

CREATE OPERATOR CLASS hash_iter_ops
    DEFAULT FOR TYPE iter USING hash AS
        OPERATOR        1       = ,
        FUNCTION        1       hash_iter(iter);


CREATE CAST (integer AS iter) WITHOUT FUNCTION AS IMPLICIT;
CREATE CAST (iter AS integer) WITHOUT FUNCTION AS IMPLICIT;


