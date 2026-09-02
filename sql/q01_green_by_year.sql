-- ============================================================================
-- q01_green_by_year.sql  (DAISY 2026, leg C, step C2 part 1: volume)
--
-- QUESTION (economics terms): is circular-economy (CE) science growing faster
--   than science as a whole? Count articles whose primary OpenAlex topic is
--   in the CE topic set, by publication year 2000 to 2025, next to all
--   articles, and take the share. Same question as leg B1 via the API
--   (group_by=publication_year), but on the full population, no 200-group
--   cap, no paging.
-- TABLES READ: subugoe-collaborative.openalex_walden.works
-- COLUMNS READ: publication_year, type, is_xpac, primary_topic.id
--   (variant 2 adds topics.id). Four scalar/leaf columns over 510M rows,
--   so this is a cheap query for a table of this size.
-- EXPECTED BYTES: TODO record at rehearsal (order of magnitude: tens of GB).
-- EXPECTED RUNTIME: TODO record at rehearsal (expect seconds).
-- API CROSS-CHECK (keyless call, 18 Aug 2026, corpus=core, same 28 topic
--   ids, type:article, publication_year:2000-2025, group_by=publication_year):
--   772,022 articles in total, 11,178 in 2000, 33,711 in 2015, 64,787 in
--   2025. BigQuery on the June 2026 snapshot should land within a few percent
--   (snapshot date and is_xpac vs corpus=core differ). TODO record the
--   BigQuery totals next to these at rehearsal.
-- STATA EQUIVALENT of the main step:
--   gen is_ce = inlist(primary_topic_id, "T12746", "T12017", ...)
--   collapse (sum) n_ce = is_ce (count) n_all = id, by(publication_year)
--   gen pct_ce = 100 * n_ce / n_all
--   (a WHERE is a keep if; GROUP BY is collapse; COUNTIF is (sum) of a 0/1)
-- SWITCH TO nber-i3: replace the table by `nber-i3.openalex.works_20260203`;
--   TODO check that it has is_xpac (q00 block a1), else drop that filter.
--
-- CE TOPIC SET: the 28 ids in the "green" CTE were pasted on 18 Aug 2026
--   from data\ce_topic_ids_sql.txt (daisy_group = circular_economy in
--   data\green_topics.csv, derived from the DATT green/digital topic list);
--   names in the trailing comments come from green_topics.csv. If the list
--   changes, rerun _build\paste_ce_ids.py or paste by hand (one quoted full
--   URL per line, comma separated, no comma after the last one).
-- ============================================================================

-- STEP 0: the CE topic set as a one-column table built from an array literal.
--   Inlining the ids means nobody has to upload a CSV to run the script.
--   (Stata: a local macro or a small dataset to merge on.)
WITH green AS (
  SELECT id
  FROM UNNEST([
    'https://openalex.org/T10171',   -- Biofuel production and bioconversion
    'https://openalex.org/T10264',   -- Asphalt Pavement Performance Evaluation
    'https://openalex.org/T10284',   -- Anaerobic Digestion and Biogas Production
    'https://openalex.org/T10435',   -- Environmental Impact and Sustainability
    'https://openalex.org/T10539',   -- Sustainable Supply Chain Management
    'https://openalex.org/T10753',   -- Microplastics and Plastic Pollution
    'https://openalex.org/T11091',   -- Extraction and Separation Processes
    'https://openalex.org/T11108',   -- Municipal Solid Waste Management
    'https://openalex.org/T11275',   -- Composting and Vermicomposting Techniques
    'https://openalex.org/T11672',   -- Recycling and utilization of industrial and municipal waste in materials production
    'https://openalex.org/T11781',   -- Wastewater Treatment and Reuse
    'https://openalex.org/T11847',   -- Recycled Aggregate Concrete Performance
    'https://openalex.org/T12017',   -- Recycling and Waste Management Techniques
    'https://openalex.org/T12118',   -- Forest Biomass Utilization and Management
    'https://openalex.org/T12186',   -- Phosphorus and nutrient management
    'https://openalex.org/T12746',   -- Sustainable Industrial Ecology
    'https://openalex.org/T12774',   -- Bauxite Residue and Utilization
    'https://openalex.org/T12838',   -- Photovoltaic Systems and Sustainability
    'https://openalex.org/T12920',   -- Healthcare and Environmental Waste Management
    'https://openalex.org/T13045',   -- Industrial Engineering and Technologies
    'https://openalex.org/T13140',   -- Materials Engineering and Processing
    'https://openalex.org/T13180',   -- Chemistry and Chemical Engineering
    'https://openalex.org/T13240',   -- Bioeconomy and Sustainability Development
    'https://openalex.org/T13477',   -- Sustainable Design and Development
    'https://openalex.org/T13790',   -- Waste Management and Environmental Impact
    'https://openalex.org/T14138',   -- Life Cycle Costing Analysis
    'https://openalex.org/T14164',   -- Marine and Offshore Engineering Studies
    'https://openalex.org/T14179'    -- Waste Management and Recycling
  ]) AS id
),

-- STEP 1: one row per article with a 0/1 flag "primary topic is CE".
--   The WHERE restricts to journal articles, core corpus, 2000 to 2025.
--   (Stata: keep if type == "article" & year >= 2000 & year <= 2025;
--    gen is_ce = ...)
flagged AS (
  SELECT
    w.publication_year,                                        -- year of publication
    w.primary_topic.id IN (SELECT id FROM green) AS is_ce      -- TRUE if primary topic in the CE set
                                                               -- (NULL if the work has no topic)
  FROM `subugoe-collaborative.openalex_walden.works` AS w
  WHERE w.type = 'article'                                     -- journal articles only
    AND NOT w.is_xpac                                          -- core corpus, drop xpac records
    AND w.publication_year BETWEEN 2000 AND 2025               -- year window
)

-- STEP 2: collapse to one row per year: CE articles, all articles, share.
SELECT
  publication_year,                                            -- year
  COUNTIF(is_ce)                              AS n_ce_articles,   -- articles with a CE primary topic
  COUNT(*)                                    AS n_all_articles,  -- all articles that year
  ROUND(100 * COUNTIF(is_ce) / COUNT(*), 3)   AS pct_ce            -- share in percent
FROM flagged                                                   -- the one-row-per-article table of STEP 1
GROUP BY publication_year                                      -- collapse by year
ORDER BY publication_year;                                     -- chronological output


-- ---------------------------------------------------------------------------
-- VARIANT 2 (commented): count a work as CE if ANY of its topics (the topics[]
--   array, up to three per work, ordered by score) is in the CE set, not only
--   the primary one. This is a superset of the primary-topic count and is
--   the BigQuery twin of the API filter topics.id (vs primary_topic.id).
--   EXISTS(...) over UNNEST(w.topics) tests the array row by row without
--   duplicating the work (unlike a CROSS JOIN UNNEST, which would). Costs the
--   extra leaf column topics.id.
--   The CE set is packed into ONE ARRAY (green_arr, a one-row CTE) and tested
--   with IN UNNEST(g.ids): a subquery "IN (SELECT id FROM green)" inside the
--   correlated EXISTS can be rejected by BigQuery ("Correlated subqueries that
--   reference other tables are not supported unless they can be
--   de-correlated"), and so can a JOIN to green inside the EXISTS. The array
--   form has no such restriction.
--   TODO record at rehearsal: bytes and how much larger the counts are.
-- ---------------------------------------------------------------------------
-- WITH green AS (
--   SELECT id FROM UNNEST([
--    'https://openalex.org/T10171',   -- Biofuel production and bioconversion
--    'https://openalex.org/T10264',   -- Asphalt Pavement Performance Evaluation
--    'https://openalex.org/T10284',   -- Anaerobic Digestion and Biogas Production
--    'https://openalex.org/T10435',   -- Environmental Impact and Sustainability
--    'https://openalex.org/T10539',   -- Sustainable Supply Chain Management
--    'https://openalex.org/T10753',   -- Microplastics and Plastic Pollution
--    'https://openalex.org/T11091',   -- Extraction and Separation Processes
--    'https://openalex.org/T11108',   -- Municipal Solid Waste Management
--    'https://openalex.org/T11275',   -- Composting and Vermicomposting Techniques
--    'https://openalex.org/T11672',   -- Recycling and utilization of industrial and municipal waste in materials production
--    'https://openalex.org/T11781',   -- Wastewater Treatment and Reuse
--    'https://openalex.org/T11847',   -- Recycled Aggregate Concrete Performance
--    'https://openalex.org/T12017',   -- Recycling and Waste Management Techniques
--    'https://openalex.org/T12118',   -- Forest Biomass Utilization and Management
--    'https://openalex.org/T12186',   -- Phosphorus and nutrient management
--    'https://openalex.org/T12746',   -- Sustainable Industrial Ecology
--    'https://openalex.org/T12774',   -- Bauxite Residue and Utilization
--    'https://openalex.org/T12838',   -- Photovoltaic Systems and Sustainability
--    'https://openalex.org/T12920',   -- Healthcare and Environmental Waste Management
--    'https://openalex.org/T13045',   -- Industrial Engineering and Technologies
--    'https://openalex.org/T13140',   -- Materials Engineering and Processing
--    'https://openalex.org/T13180',   -- Chemistry and Chemical Engineering
--    'https://openalex.org/T13240',   -- Bioeconomy and Sustainability Development
--    'https://openalex.org/T13477',   -- Sustainable Design and Development
--    'https://openalex.org/T13790',   -- Waste Management and Environmental Impact
--    'https://openalex.org/T14138',   -- Life Cycle Costing Analysis
--    'https://openalex.org/T14164',   -- Marine and Offshore Engineering Studies
--    'https://openalex.org/T14179'    -- Waste Management and Recycling
--   ]) AS id
-- ),
-- green_arr AS (
--   SELECT ARRAY_AGG(id) AS ids FROM green                             -- the same set packed into one array (one row)
-- ),
-- flagged AS (
--   SELECT
--     w.publication_year,
--     w.primary_topic.id IN UNNEST(g.ids) AS is_ce_primary,           -- primary topic in set
--     EXISTS (SELECT 1                                                 -- any topic in set
--             FROM UNNEST(w.topics) AS t
--             WHERE t.id IN UNNEST(g.ids)) AS is_ce_any                -- array test, no correlated subquery on another table
--   FROM `subugoe-collaborative.openalex_walden.works` AS w
--   CROSS JOIN green_arr AS g                                          -- one row: attaches the array to every work
--   WHERE w.type = 'article'
--     AND NOT w.is_xpac
--     AND w.publication_year BETWEEN 2000 AND 2025
-- )
-- SELECT
--   publication_year,
--   COUNTIF(is_ce_primary)                          AS n_ce_primary,
--   COUNTIF(is_ce_any)                              AS n_ce_any_topic,
--   COUNT(*)                                        AS n_all_articles,
--   ROUND(100 * COUNTIF(is_ce_primary) / COUNT(*), 3) AS pct_ce_primary,
--   ROUND(100 * COUNTIF(is_ce_any) / COUNT(*), 3)     AS pct_ce_any_topic
-- FROM flagged
-- GROUP BY publication_year
-- ORDER BY publication_year;
