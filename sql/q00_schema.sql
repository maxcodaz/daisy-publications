-- ============================================================================
-- q00_schema.sql  (DAISY 2026, leg C, step C1: "a record, seen from SQL")
--
-- QUESTION (economics terms): before counting anything, what does one
--   publication record contain, and which nested fields carry the variables
--   an economist needs (year, type, topic, authors' countries, citations,
--   references, SDG tags, open access, venue)?
-- TABLES READ:
--   subugoe-collaborative.openalex_walden.works           (June 2026 OpenAlex
--       snapshot loaded by SUB Goettingen on 8 Jul 2026, 510,372,821 rows,
--       nested schema identical to the OpenAlex JSON, includes the 190M
--       "xpac" records flagged by is_xpac)
--   subugoe-collaborative.openalex_walden.INFORMATION_SCHEMA.COLUMNS
--   subugoe-collaborative.openalex_walden.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS
--   subugoe-collaborative.openalex_walden.__TABLES__      (row counts, bytes)
-- COLUMNS READ (works): id, doi, publication_year, type, is_xpac,
--   primary_topic.display_name, authorships (ARRAY_LENGTH only), cited_by_count
-- EXPECTED BYTES: block (a) is metadata, free. Block (b): TODO record the
--   estimate at rehearsal (the point of the block: LIMIT 5 still bills the
--   full columns, expect tens of GB). Block (c) is a comment, nothing runs.
-- EXPECTED RUNTIME: TODO record at rehearsal.
-- STATA EQUIVALENT: describe (block a); list in 1/5 (block b, but Stata's
--   list is free, BigQuery's is not).
-- SWITCH TO nber-i3: replace `subugoe-collaborative.openalex_walden.works`
--   with `nber-i3.openalex.works_20260203` (same nested OpenAlex layout;
--   TODO check at rehearsal whether that table has an is_xpac column, via
--   the INFORMATION_SCHEMA query below with the dataset name swapped; if it
--   does not, delete the "AND NOT is_xpac" filter everywhere).
--
-- Field names below were checked on 18 Aug 2026 against the loader schema
-- github.com/naustica/openalex/blob/main/schemas/schema_openalex_work.json:
--   id STRING, doi STRING, publication_year INT64, publication_date STRING,
--   type STRING, is_xpac BOOL, cited_by_count INT64, has_abstract BOOL,
--   fwci FLOAT64, citation_normalized_percentile RECORD, authors_count INT64,
--   countries_distinct_count INT64,
--   authorships ARRAY<STRUCT<author STRUCT<id, display_name, orcid>,
--       author_position STRING, countries ARRAY<STRING>,
--       institutions ARRAY<STRUCT<id, display_name, ror, country_code, type,
--       lineage>>, is_corresponding BOOL, raw_affiliation_strings ...>>,
--   primary_topic STRUCT<id, display_name, score, subfield STRUCT<id,
--       display_name>, field STRUCT<id, display_name>, domain STRUCT<...>>,
--   topics ARRAY<same STRUCT>,
--   sustainable_development_goals ARRAY<STRUCT<id, display_name, score>>,
--   referenced_works ARRAY<STRING>, referenced_works_count INT64,
--   open_access STRUCT<is_oa BOOL, oa_status, oa_url, ...>,
--   primary_location STRUCT<source STRUCT<id, display_name, issn_l,
--       issn ARRAY<STRING>, type, is_oa, is_in_doaj, ...>, ...>.
-- Ids are full URLs as in the JSON: id = 'https://openalex.org/W...',
--   primary_topic.id = 'https://openalex.org/T10471',
--   doi = 'https://doi.org/10....' (lower case).
-- ============================================================================


-- ---------------------------------------------------------------------------
-- (a1) TOP-LEVEL COLUMNS USED IN THE DEMO. INFORMATION_SCHEMA is metadata:
--      no bytes billed. data_type prints the whole STRUCT for nested columns,
--      which is exactly what we want the room to see.
-- ---------------------------------------------------------------------------
SELECT
  column_name,                                     -- name of the top-level column
  data_type                                        -- STRING / INT64 / ARRAY<STRUCT<...>>
FROM `subugoe-collaborative.openalex_walden.INFORMATION_SCHEMA.COLUMNS`   -- metadata view of the dataset (if the console rejects the fully backticked name, write `subugoe-collaborative`.openalex_walden.INFORMATION_SCHEMA.COLUMNS)
WHERE table_name = 'works'                         -- only the works table
  AND column_name IN (                             -- the fields the demo touches
    'id', 'doi', 'publication_year', 'type', 'is_xpac',
    'authorships', 'primary_topic', 'topics',
    'cited_by_count', 'referenced_works',
    'sustainable_development_goals', 'open_access', 'primary_location',
    'countries_distinct_count', 'authors_count', 'has_abstract'
  )
ORDER BY ordinal_position;                         -- keep the table's own order


-- ---------------------------------------------------------------------------
-- (a2) NESTED FIELD PATHS. COLUMN_FIELD_PATHS lists every leaf inside the
--      STRUCT/ARRAY columns with its dotted path, the same notation used in
--      the queries (authorships.countries, primary_topic.subfield.display_name).
--      Also free.
-- ---------------------------------------------------------------------------
SELECT
  field_path,                                      -- dotted path to the leaf
  data_type                                        -- type of the leaf
FROM `subugoe-collaborative.openalex_walden.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS`   -- one row per leaf field (same backtick remark as a1)
WHERE table_name = 'works'                         -- only the works table
  AND (                                            -- only the paths the demo relies on
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
ORDER BY field_path;                               -- alphabetical


-- ---------------------------------------------------------------------------
-- (a3) HOW BIG IS IT? __TABLES__ is the legacy metadata view: row_count and
--      size_bytes for every table in the dataset, free. size_bytes of works
--      is what "SELECT * FROM works" would bill (see block c).
--      TODO record at rehearsal: row_count (expect 510,372,821) and
--      size_bytes of works, plus the sizes of authors, institutions, topics.
-- ---------------------------------------------------------------------------
SELECT
  table_id,                                        -- table name
  row_count,                                       -- number of rows
  ROUND(size_bytes / POW(1024, 3), 1) AS size_gib  -- logical size in GiB
FROM `subugoe-collaborative.openalex_walden.__TABLES__`   -- legacy metadata view, one row per table
ORDER BY size_bytes DESC;                         -- largest table first


-- ---------------------------------------------------------------------------
-- (a4) OPTIONAL, cheap: how many rows are xpac vs core? Reads one BOOL column
--      over 510M rows (roughly 0.5 GB). Shows why every query below carries
--      "AND NOT is_xpac" (xpac = the ~190M records that the API hides by
--      default since Walden, corpus=core). Also reveals whether is_xpac is
--      ever NULL: if it is, use "NOT IFNULL(is_xpac, FALSE)" instead of
--      "NOT is_xpac", because NOT NULL is NULL and drops the row.
--      TODO record at rehearsal: the three counts.
-- ---------------------------------------------------------------------------
SELECT
  is_xpac,                                         -- TRUE / FALSE / NULL
  COUNT(*) AS n_works                              -- rows in each group
FROM `subugoe-collaborative.openalex_walden.works`   -- the works table
GROUP BY is_xpac                                   -- three groups at most
ORDER BY is_xpac;                                  -- FALSE, TRUE, NULL


-- ---------------------------------------------------------------------------
-- (b) A FIVE-ROW PREVIEW WITH SQL. Read the estimate in the top-right corner
--     of the editor BEFORE running: LIMIT 5 does not reduce billed bytes,
--     BigQuery still reads the full columns listed in SELECT and WHERE for
--     all 510M rows (unless the table is partitioned on publication_year,
--     TODO check the "Details" tab at rehearsal). The free way to look at
--     rows is the "Preview" tab of the table in the console. This block is
--     here to make that point, decide at rehearsal whether to actually run
--     it or only show the estimate.
--     TODO record at rehearsal: estimated bytes, runtime.
-- ---------------------------------------------------------------------------
SELECT
  id,                                              -- 'https://openalex.org/W...'
  doi,                                             -- 'https://doi.org/10....' or NULL
  publication_year,                                -- INT64
  type,                                            -- 'article', 'book-chapter', 'preprint', ...
  primary_topic.display_name AS topic,             -- one of ~4,516 topic labels
  ARRAY_LENGTH(authorships)  AS n_authors,         -- length of the authorships array
                                                   -- (authors_count is the cheap scalar twin)
  cited_by_count                                   -- citations received, snapshot date
FROM `subugoe-collaborative.openalex_walden.works`   -- the works table
WHERE publication_year = 2024                      -- one year
  AND NOT is_xpac                                  -- core corpus only
LIMIT 5;                                           -- 5 rows shown, full columns billed


-- ---------------------------------------------------------------------------
-- (c) THE "SELECT *" SIN. Do not run this:
--
--       SELECT * FROM `subugoe-collaborative.openalex_walden.works` LIMIT 10;
--
--     Type it in the editor and read the validator line at the top right:
--     "This query will process X TB when run" (green tick, hover for the
--     exact figure). That X equals size_bytes from block (a3): SELECT * reads
--     every column of every row, LIMIT changes nothing, and on-demand pricing
--     is $6.25 per TiB after the free 1 TiB per month. The same dry run from
--     the command line: bq query --dry_run --use_legacy_sql=false 'SELECT ...'
--     (prints "Query successfully validated. Assuming the tables are not
--     modified, running this query will process N bytes of data"); in Python:
--     bigquery.QueryJobConfig(dry_run=True) then job.total_bytes_processed.
--     Rules of thumb: name the columns you need (BigQuery is columnar, it
--     bills only the leaves you touch, so authorships.countries costs far less
--     than authorships), filter on partition columns when the table has them,
--     and remember that a repeated query with identical text is served from
--     cache for free within 24 hours.
-- ---------------------------------------------------------------------------
