-- ============================================================================
-- q00a_warmup.sql  (DAISY 2026 BigQuery demo: first queries)
-- Four statements of growing size, run one at a time: select a block, read
-- the estimate at the top right, Ctrl+Enter. (1) is free; (2) to (4) read
-- only id and small columns, a few GB each.
-- Table: subugoe-collaborative.openalex_walden.works (510,372,821 rows).
-- ============================================================================


-- ---------------------------------------------------------------------------
-- (1) THE SMALLEST POSSIBLE QUERY. FROM says where, SELECT says what.
--     Row counts are metadata: the estimate reads 0 B, running it is free.
-- ---------------------------------------------------------------------------
SELECT COUNT(*)                                    -- count the rows
FROM `subugoe-collaborative.openalex_walden.works`;  -- the three-part address


-- ---------------------------------------------------------------------------
-- (2) CHOOSE ROWS AND COLUMNS. WHERE filters rows, SELECT keeps the named
--     columns. Uncomment the display_name line, pause on the estimate (the
--     title column makes the GB jump), re-comment, then run.
-- ---------------------------------------------------------------------------
SELECT
  id,                                              -- OpenAlex work id
  doi,                                             -- DOI as a URL
  -- display_name,                                 -- UNCOMMENT for the estimate demo, RE-COMMENT before running
  publication_year,                                -- year
  cited_by_count                                   -- citations received
FROM `subugoe-collaborative.openalex_walden.works`
WHERE cited_by_count > 100                         -- highly cited
  AND publication_year > 2010                      -- recent
  AND NOT is_xpac;                                 -- core records only


-- ---------------------------------------------------------------------------
-- (3) MAKE NEW COLUMNS, SORT. AS renames, CASE WHEN builds a dummy,
--     ORDER BY sorts. Same estimate as (2): computed columns are free,
--     you pay for the inputs.
-- ---------------------------------------------------------------------------
SELECT
  id,
  publication_year,
  cited_by_count AS cites,                         -- rename
  CASE WHEN publication_year >= 2016 THEN 1 ELSE 0 END AS post2016  -- dummy
FROM `subugoe-collaborative.openalex_walden.works`
WHERE cited_by_count > 100
  AND publication_year > 2010
  AND NOT is_xpac
ORDER BY cites DESC;                               -- most cited first


-- ---------------------------------------------------------------------------
-- (4) AGGREGATE. GROUP BY collapses half a billion rows into 26: articles
--     per year, the growth of science on one screen. The shape of almost
--     every research query: filter, group, count.
-- ---------------------------------------------------------------------------
SELECT
  publication_year,                                -- one row per year
  COUNT(*) AS n_articles                           -- articles that year
FROM `subugoe-collaborative.openalex_walden.works`
WHERE publication_year BETWEEN 2000 AND 2025       -- the demo window
  AND type = 'article'                             -- articles only
  AND NOT is_xpac
GROUP BY publication_year
ORDER BY publication_year;
