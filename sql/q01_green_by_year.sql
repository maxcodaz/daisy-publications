-- ============================================================================
-- q01_green_by_year.sql  (DAISY 2026 BigQuery demo, C2: volume)
-- Circular-economy (CE) articles per year next to all articles, and the
-- share: is CE science growing faster than science? Reads 4 small columns;
-- check the estimate before running.
-- Table: subugoe-collaborative.openalex_walden.works (June 2026 snapshot).
-- CE set: the 8 topics returned by the OpenAlex topics search "circular
-- economy", frozen 3 Sept 2026 (see data/README.md). Inlined below so the
-- script runs anywhere; q02 shows the upload route instead.
-- API cross-check (keyless, 4 Sept 2026, corpus=core, same filters):
-- 217,169 articles 2000-2025; 3,147 in 2000, 9,725 in 2015, 17,915 in 2025.
-- ============================================================================

-- STEP 0: the CE topic set as a one-column table built from an array literal.
WITH green AS (
  SELECT id
  FROM UNNEST([
    'https://openalex.org/T10539',   -- Sustainable Supply Chain Management
    'https://openalex.org/T11091',   -- Extraction and Separation Processes
    'https://openalex.org/T13180',   -- Chemistry and Chemical Engineering
    'https://openalex.org/T11672',   -- Recycling and utilization of industrial and municipal waste in materials production
    'https://openalex.org/T13240',   -- Bioeconomy and Sustainability Development
    'https://openalex.org/T12746',   -- Sustainable Industrial Ecology
    'https://openalex.org/T13045',   -- Industrial Engineering and Technologies
    'https://openalex.org/T13477'    -- Sustainable Design and Development
  ]) AS id
),

-- STEP 1: one row per article with a TRUE/FALSE flag "primary topic is CE".
flagged AS (
  SELECT
    w.publication_year,                                        -- year of publication
    w.primary_topic.id IN (SELECT id FROM green) AS is_ce      -- CE flag (NULL if no topic)
  FROM `subugoe-collaborative.openalex_walden.works` AS w
  WHERE w.type = 'article'                                     -- journal articles only
    AND NOT w.is_xpac                                          -- core corpus
    AND w.publication_year BETWEEN 2000 AND 2025               -- year window
)

-- STEP 2: collapse to one row per year: CE articles, all articles, share.
SELECT
  publication_year,                                            -- year
  COUNTIF(is_ce)                              AS n_ce_articles,   -- CE articles
  COUNT(*)                                    AS n_all_articles,  -- all articles
  ROUND(100 * COUNTIF(is_ce) / COUNT(*), 3)   AS pct_ce            -- share in percent
FROM flagged
GROUP BY publication_year
ORDER BY publication_year;


-- ---------------------------------------------------------------------------
-- VARIANT (commented): count a work as CE if ANY of its up-to-3 topics is in
--   the set, not only the primary one (the twin of the API filter topics.id).
--   The set is packed into one array and tested with IN UNNEST(g.ids),
--   because a correlated subquery on another table inside EXISTS is rejected.
-- ---------------------------------------------------------------------------
-- WITH green AS (
--   SELECT id FROM UNNEST([
--    'https://openalex.org/T10539',   -- Sustainable Supply Chain Management
--    'https://openalex.org/T11091',   -- Extraction and Separation Processes
--    'https://openalex.org/T13180',   -- Chemistry and Chemical Engineering
--    'https://openalex.org/T11672',   -- Recycling and utilization of industrial and municipal waste in materials production
--    'https://openalex.org/T13240',   -- Bioeconomy and Sustainability Development
--    'https://openalex.org/T12746',   -- Sustainable Industrial Ecology
--    'https://openalex.org/T13045',   -- Industrial Engineering and Technologies
--    'https://openalex.org/T13477'    -- Sustainable Design and Development
--   ]) AS id
-- ),
-- green_arr AS (
--   SELECT ARRAY_AGG(id) AS ids FROM green                             -- the set as one array (one row)
-- ),
-- flagged AS (
--   SELECT
--     w.publication_year,
--     w.primary_topic.id IN UNNEST(g.ids) AS is_ce_primary,           -- primary topic in set
--     EXISTS (SELECT 1                                                 -- any topic in set
--             FROM UNNEST(w.topics) AS t
--             WHERE t.id IN UNNEST(g.ids)) AS is_ce_any
--   FROM `subugoe-collaborative.openalex_walden.works` AS w
--   CROSS JOIN green_arr AS g                                          -- one row: attach the array to every work
--   WHERE w.type = 'article'
--     AND NOT w.is_xpac
--     AND w.publication_year BETWEEN 2000 AND 2025
-- )
-- SELECT
--   publication_year,
--   COUNTIF(is_ce_primary)                            AS n_ce_primary,
--   COUNTIF(is_ce_any)                                AS n_ce_any_topic,
--   COUNT(*)                                          AS n_all_articles,
--   ROUND(100 * COUNTIF(is_ce_primary) / COUNT(*), 3) AS pct_ce_primary,
--   ROUND(100 * COUNTIF(is_ce_any) / COUNT(*), 3)     AS pct_ce_any_topic
-- FROM flagged
-- GROUP BY publication_year
-- ORDER BY publication_year;
