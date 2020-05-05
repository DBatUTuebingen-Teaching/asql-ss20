-- 1. 

-------------------------------------------------------------------------------

-- 2.

DROP TABLE tree;
CREATE TABLE tree (
  level_a char(2),
  level_b char(2),
  level_c char(2),
  level_d CHAR(2),
  leaf_value int
);

INSERT INTO tree VALUES
('A1', 'B1', 'C1', 'D1', 1),
('A1', 'B1', 'C1', 'D2', 2),
('A1', 'B1', 'C2', 'D3', 4),
('A1', 'B1', 'C2', 'D4', 8),
('A1', 'B2', 'C3', 'D5', 16),
('A1', 'B2', 'C3', 'D6', 32),
('A1', 'B2', 'C4', NULL, 64);