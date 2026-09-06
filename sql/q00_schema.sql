-- ============================================================================
-- q00_schema.sql  (DAISY 2026 BigQuery demo, reference: the works table)
-- Inspect the table before spending anything: its columns, its size, the
-- xpac/core split, and why SELECT * is never typed. Blocks (a) read free
-- metadata; block (b) costs real bytes; block (c) is estimate-only.
-- Table: subugoe-collaborative.openalex_walden.works, June 2026 OpenAlex
-- snapshot, 510,372,821 rows including ~190M "xpac" records (is_xpac);
-- loader and full schema: github.com/naustica/openalex.
-- ============================================================================


-- ---------------------------------------------------------------------------
-- (a1) TOP-LEVEL COLUMNS USED IN THE DEMO. INFORMATION_SCHEMA is metadata,
--      no bytes billed. data_type prints the whole STRUCT for nested columns.
--      If the console rejects the fully backticked name, write
--      `subugoe-collaborative`.openalex_walden.INFORMATION_SCHEMA.COLUMNS.
-- ---------------------------------------------------------------------------
SELECT
  column_name,                                     -- name of the top-level column
  data_type                                        -- STRING / INT64 / ARRAY<STRUCT<...>>
FROM `subugoe-collaborative.openalex_walden.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'works'
  AND column_name IN (                             -- the fields the demo touches
    'id', 'doi', 'publication_year', 'type', 'is_xpac',
    'authorships', 'primary_topic', 'topics',
    'cited_by_count', 'referenced_works',
    'sustainable_development_goals', 'open_access', 'primary_location',
    'countries_distinct_count', 'authors_count', 'has_abstract'
  )
ORDER BY ordinal_position;


-- ---------------------------------------------------------------------------
-- (a2) NESTED FIELD PATHS: every leaf inside the STRUCT/ARRAY columns, with
--      the dotted path used in queries (authorships.countries, ...). Free.
-- ---------------------------------------------------------------------------
SELECT
  field_path,                                      -- dotted path to the leaf
  data_type                                        -- type of the leaf
FROM `subugoe-collaborative.openalex_walden.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS`
WHERE table_name = 'works'
  AND (
       field_path LIKE 'authorships.countries%'
    OR field_path LIKE 'authorships.institutions.country_code%'
    OR field_path LIKE 'primary_topic.%'
    OR field_path LIKE 'topics.id%'
    OR field_path LIKE 'sustainable_development_goals.%'
    OR field_path LIKE 'open_access.is_oa%'
    OR field_path LIKE 'primary_location.source.display_name%'
    OR field_path IN ('publication_year', 'type', 'is_xpac', 'doi',
                      'cited_by_count', 'referenced_works')
  )
ORDER BY field_path;


-- ---------------------------------------------------------------------------
-- (a3) HOW BIG IS IT? __TABLES__ gives row_count and size_bytes per table,
--      free. size_bytes of works is what "SELECT *" would bill (block c).
-- ---------------------------------------------------------------------------
SELECT
  table_id,                                        -- table name
  row_count,                                       -- number of rows
  ROUND(size_bytes / POW(1024, 3), 1) AS size_gib  -- logical size in GiB
FROM `subugoe-collaborative.openalex_walden.__TABLES__`
ORDER BY size_bytes DESC;


-- ---------------------------------------------------------------------------
-- (a4) XPAC vs CORE. Reads one BOOL column over 510M rows (~0.5 GB). Shows
--      why every query carries "AND NOT is_xpac" (xpac = the ~190M records
--      the API hides by default, corpus=core). If is_xpac is ever NULL, use
--      "NOT IFNULL(is_xpac, FALSE)": NOT NULL is NULL and drops the row.
-- ---------------------------------------------------------------------------
SELECT
  is_xpac,                                         -- TRUE / FALSE / NULL
  COUNT(*) AS n_works                              -- rows in each group
FROM `subugoe-collaborative.openalex_walden.works`
GROUP BY is_xpac
ORDER BY is_xpac;


-- ---------------------------------------------------------------------------
-- (b) A FIVE-ROW PREVIEW WITH SQL. Read the estimate BEFORE running: LIMIT 5
--     does not reduce billed bytes, the full columns are read for all 510M
--     rows. The free way to look at rows is the table's Preview tab.
-- ---------------------------------------------------------------------------
SELECT
  id,                                              -- 'https://openalex.org/W...'
  doi,                                             -- 'https://doi.org/10....' or NULL
  publication_year,                                -- INT64
  type,                                            -- 'article', 'book-chapter', ...
  primary_topic.display_name AS topic,             -- one of ~4,516 topic labels
  ARRAY_LENGTH(authorships)  AS n_authors,         -- length of the authorships array
  cited_by_count                                   -- citations received
FROM `subugoe-collaborative.openalex_walden.works`
WHERE publication_year = 2024                      -- one year
  AND NOT is_xpac                                  -- core corpus only
LIMIT 5;                                           -- 5 rows shown, full columns billed


-- ---------------------------------------------------------------------------
-- (c) THE "SELECT *" SIN. Do not run this:
--
--       SELECT * FROM `subugoe-collaborative.openalex_walden.works` LIMIT 10;
--
--     Type it and read the validator line at the top right: it will process
--     the full size_bytes of block (a3), about a terabyte and a half, and
--     LIMIT changes nothing. On-demand pricing is $6.25 per TiB after the
--     free 1 TiB per month. Rules of thumb: name the columns you need
--     (BigQuery is columnar, it bills the leaves you touch), and an
--     identical query repeated within 24 hours is served from cache, free.
-- ---------------------------------------------------------------------------
