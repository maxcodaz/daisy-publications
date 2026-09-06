-- ============================================================================
-- q02_green_by_country.sql  (DAISY 2026 BigQuery demo: geography)
-- Which countries produce CE science and which specialise in it: full and
-- fractional counting, shares, RTA = (country CE share) / (world CE share).
-- Top 20 by CE count; Italy is inside (adapting the script to a country
-- outside the top 20 means raising the LIMIT or adding a WHERE).
-- Tables: subugoe-collaborative.openalex_walden.works, plus the CE topic
-- list uploaded once as your-project-id.daisy.ce_topics (STEP 0).
-- your-project-id IS A PLACEHOLDER: replace it everywhere (Ctrl+H) by your
-- own project id (shown in the console's project picker).
-- Missing countries: about a third of articles carry no author country and
-- drop out of every count below (about 62% of all articles 2015-2025 have
-- at least one author country, 66% of CE articles).
-- Read the results as "among articles with a known author country".
-- ============================================================================

-- STEP 0, once: a dataset of your own, then the CE topic list uploaded into
--   it. Run the statement below first (the dataset location must match the
--   source dataset's: console, Details tab of openalex_walden). Then upload
--   the handout file ce_topics.csv: + Add > Local file > ce_topics.csv,
--   dataset daisy, table name ce_topics, auto-detect schema. Free.
CREATE SCHEMA IF NOT EXISTS `your-project-id.daisy`
OPTIONS (location = 'US', description = 'DAISY 2026 BigQuery demo');


-- STEP 1: one row per (article, country). THE JOIN EXPLOSION: the comma
--   before UNNEST is a CROSS JOIN, so each work becomes one row per author,
--   then one row per country of that author. A paper with 5 Italian authors
--   would give 5 rows for IT; SELECT DISTINCT collapses them to one
--   (article, country) pair. Works with no author country are dropped.
--   The CE flag now comes from the uploaded table, not an inline list.
WITH pairs AS (
  SELECT DISTINCT
    w.id,                                                            -- work id
    IFNULL(w.primary_topic.id IN (
      SELECT topic_id_url FROM `your-project-id.daisy.ce_topics`
    ), FALSE) AS is_ce,                                              -- CE flag, FALSE if no topic
    c AS country                                                     -- ISO-2 code, e.g. 'IT'
  FROM `subugoe-collaborative.openalex_walden.works` AS w,
    UNNEST(w.authorships) AS a,                                      -- one row per author
    UNNEST(a.countries)   AS c                                       -- one row per country of that author
  WHERE w.type = 'article'                                           -- journal articles only
    AND NOT w.is_xpac                                                -- core corpus
    AND w.publication_year BETWEEN 2015 AND 2025                     -- year window
),

-- STEP 2: number of distinct countries per article, the denominator of the
--   fractional weight (the ready-made column countries_distinct_count gives
--   the same number; built here so the weight is visible).
k AS (
  SELECT
    id,
    COUNT(*) AS n_countries                                          -- rows per id = distinct countries
  FROM pairs
  GROUP BY id
),

-- STEP 3: collapse to one row per country. Full counting = COUNT(*) works
--   because STEP 1 guarantees one row per (article, country); fractional =
--   sum of 1/n_countries. The literature calls full "whole counting".
by_country AS (
  SELECT
    p.country,
    COUNTIF(p.is_ce)                                 AS ce_full,     -- CE articles, full counting
    SUM(IF(p.is_ce, 1.0 / k.n_countries, 0.0))       AS ce_frac,     -- CE articles, fractional
    COUNT(*)                                         AS all_full,    -- all articles, full
    SUM(1.0 / k.n_countries)                         AS all_frac     -- all articles, fractional
  FROM pairs AS p
  JOIN k ON k.id = p.id                                              -- attach n_countries
  GROUP BY p.country
),

-- STEP 4: world CE share. No GROUP BY country here: the query runs over all
--   of pairs, where a three-country article sits three times, so the
--   COUNT(DISTINCT ...) is load-bearing. Do not simplify it to COUNT(*).
--   Fractional weights sum to 1 per article, so one denominator works for
--   both RTA versions.
world AS (
  SELECT
    COUNT(DISTINCT IF(is_ce, id, NULL)) / COUNT(DISTINCT id) AS world_share_ce
  FROM pairs
)

-- STEP 5: the 20 largest CE producers, shares and RTA under both counting
--   rules. RTA > 1: more specialised in CE than the world. The console's
--   Row column is the rank (output sorted by ce_full).
SELECT
  b.country,                                                         -- ISO-2 code
  b.ce_full,                                                         -- CE articles, full
  ROUND(b.ce_frac, 1)                                  AS ce_frac,   -- CE articles, fractional
  b.all_full,                                                        -- all articles, full
  ROUND(b.all_frac, 1)                                 AS all_frac,  -- all articles, fractional
  ROUND(100 * b.ce_full / b.all_full, 3)               AS pct_ce_full,    -- country CE share, full
  ROUND(100 * b.ce_frac / b.all_frac, 3)               AS pct_ce_frac,    -- country CE share, fractional
  ROUND(100 * w.world_share_ce, 3)                     AS pct_ce_world,   -- world CE share
  ROUND((b.ce_full / b.all_full) / w.world_share_ce, 3)   AS rta_full,    -- RTA, full counting
  ROUND((b.ce_frac / b.all_frac)  / w.world_share_ce, 3)  AS rta_frac     -- RTA, fractional
FROM by_country AS b
CROSS JOIN world AS w                                                -- one-row table, attach to every country
ORDER BY b.ce_full DESC
LIMIT 20;


-- NOTES
-- * pairs is referenced three times (k, by_country, world); if the dry-run
--   estimate is about three times q01's, materialise pairs as a table once
--   and run the later steps on it.
-- * Full counts across countries add up to more than the number of articles
--   (international papers count once per country); fractional counts add up
--   exactly to the number of articles with a country.
