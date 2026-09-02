-- ============================================================================
-- q02_green_by_country.sql  (DAISY 2026, leg C, step C2 part 2: geography)
--
-- QUESTION (economics terms): who produces circular-economy (CE) science, and
--   who specialises in it? For articles 2015 to 2025: CE articles by country
--   under whole counting (a paper with authors from 3 countries counts once
--   for each) and fractional counting (each country gets 1/3), the top 20
--   countries plus Italy, and a revealed technological advantage index
--   RTA = (country's CE share of its own articles) / (world CE share),
--   with the all-articles denominator built exactly the same way.
--   Same question as leg B2 via the API (group_by=authorships.countries),
--   but here the fractional version is possible (the API cannot do it).
-- TABLES READ: subugoe-collaborative.openalex_walden.works
-- COLUMNS READ: id, publication_year, type, is_xpac, primary_topic.id,
--   authorships.countries (BigQuery is columnar: only that leaf of the
--   authorships record is read, not names or institutions)
-- EXPECTED BYTES: TODO record at rehearsal (larger than q01 because of
--   id and authorships.countries; expect a few hundred GB at most).
-- EXPECTED RUNTIME: TODO record at rehearsal (expect well under a minute).
-- STATA EQUIVALENT of the main step (after a long file with one row per
--   article x author x country, i.e. after the two UNNESTs):
--   duplicates drop id country, force              // = SELECT DISTINCT
--   bysort id: gen frac = 1 / _N                   // 1 / n countries on the paper
--   collapse (count) whole = id (sum) frac, by(country is_ce)   // = GROUP BY
--   then reshape wide and compute shares and the RTA ratio.
-- SWITCH TO nber-i3: replace the table by `nber-i3.openalex.works_20260203`;
--   TODO check that it has is_xpac (q00 block a1), else drop that filter.
--   authorships.countries exists in the i3 nested layout as well; if it did
--   not, use UNNEST(a.institutions) AS i and i.country_code instead.
--
-- CE TOPIC SET: the same 28 ids as q01, pasted on 18 Aug 2026 from
--   data\ce_topic_ids_sql.txt (rerun _build\paste_ce_ids.py if it changes).
-- ============================================================================

-- STEP 0: CE topic set (see q01).
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

-- STEP 1: one row per (article, country). THE JOIN EXPLOSION: the comma
--   before UNNEST is a CROSS JOIN, so each work becomes one row per author
--   (UNNEST(w.authorships)) and then one row per country of that author
--   (UNNEST(a.countries)). A paper with 5 authors, all Italian, would give 5
--   rows for IT; SELECT DISTINCT collapses them to one (article, country)
--   pair, so Italy counts the paper once. Works with no author country are
--   dropped by the CROSS JOIN (use LEFT JOIN UNNEST(...) to keep them).
--   (Stata: reshape long, then duplicates drop id country.)
pairs AS (
  SELECT DISTINCT
    w.id,                                                            -- work id
    IFNULL(w.primary_topic.id IN (SELECT id FROM green), FALSE) AS is_ce,  -- CE flag, FALSE if no topic
    c AS country                                                     -- ISO-2 country code, e.g. 'IT'
  FROM `subugoe-collaborative.openalex_walden.works` AS w,
    UNNEST(w.authorships) AS a,                                      -- one row per author
    UNNEST(a.countries)   AS c                                       -- one row per country of that author
  WHERE w.type = 'article'                                           -- journal articles only
    AND NOT w.is_xpac                                                -- core corpus
    AND w.publication_year BETWEEN 2015 AND 2025                     -- year window
),

-- STEP 2: number of distinct countries per article, the denominator of the
--   fractional weight. (Stata: bysort id: gen n_countries = _N)
k AS (
  SELECT
    id,                                                              -- work id
    COUNT(*) AS n_countries                                          -- rows per id = distinct countries
  FROM pairs
  GROUP BY id
),

-- STEP 3: collapse to one row per country. Whole = number of distinct
--   articles with at least one author in the country (COUNT(DISTINCT id);
--   after STEP 1's DISTINCT this equals COUNT(*), the DISTINCT is kept as a
--   guard). Fractional = sum of 1/n_countries over the country's articles.
--   (Stata: collapse (count) whole = id (sum) frac, by(country))
by_country AS (
  SELECT
    p.country,                                                       -- country code
    COUNT(DISTINCT IF(p.is_ce, p.id, NULL))          AS ce_whole,    -- CE articles, whole counting
    SUM(IF(p.is_ce, 1.0 / k.n_countries, 0.0))       AS ce_frac,     -- CE articles, fractional
    COUNT(DISTINCT p.id)                             AS all_whole,   -- all articles, whole
    SUM(1.0 / k.n_countries)                         AS all_frac     -- all articles, fractional
  FROM pairs AS p
  JOIN k ON k.id = p.id                                              -- attach n_countries (Stata: merge m:1 id)
  GROUP BY p.country
),

-- STEP 4: world CE share among articles with at least one country. Because
--   fractional weights sum to 1 per article, the fractional world share is
--   the same number, so one denominator works for both RTA versions.
world AS (
  SELECT
    COUNT(DISTINCT IF(is_ce, id, NULL)) / COUNT(DISTINCT id) AS world_share_ce  -- world share of CE
  FROM pairs
),

-- STEP 5: rank countries by CE whole count.
ranked AS (
  SELECT
    b.*,                                                             -- all country columns
    ROW_NUMBER() OVER (ORDER BY b.ce_whole DESC) AS rank_whole       -- 1 = largest CE producer
  FROM by_country AS b
)

-- STEP 6: top 20 plus Italy, with shares and RTA under both counting rules.
--   RTA > 1: the country is more specialised in CE science than the world.
SELECT
  r.rank_whole,                                                      -- rank by CE whole count
  r.country,                                                         -- ISO-2 code
  r.ce_whole,                                                        -- CE articles, whole
  ROUND(r.ce_frac, 1)                                  AS ce_frac,   -- CE articles, fractional
  r.all_whole,                                                       -- all articles, whole
  ROUND(r.all_frac, 1)                                 AS all_frac,  -- all articles, fractional
  ROUND(100 * r.ce_whole / r.all_whole, 3)             AS pct_ce_whole,   -- country CE share, whole
  ROUND(100 * r.ce_frac / r.all_frac, 3)               AS pct_ce_frac,    -- country CE share, fractional
  ROUND(100 * w.world_share_ce, 3)                     AS pct_ce_world,   -- world CE share
  ROUND((r.ce_whole / r.all_whole) / w.world_share_ce, 3) AS rta_whole,   -- RTA, whole counting
  ROUND((r.ce_frac  / r.all_frac)  / w.world_share_ce, 3) AS rta_frac     -- RTA, fractional counting
FROM ranked AS r                                                     -- one row per country, with its rank
CROSS JOIN world AS w                                                -- one-row table, attach to every country
WHERE r.rank_whole <= 20                                             -- top 20 CE producers
   OR r.country = 'IT'                                               -- plus Italy wherever it ranks
ORDER BY r.rank_whole;                                               -- largest CE producer first


-- ---------------------------------------------------------------------------
-- NOTES
-- * COST: the CTE pairs is referenced three times (k, by_country, world).
--   BigQuery may inline it and scan the works table three times; the dry-run
--   estimate at the top right shows whether it does. If the estimate is about
--   three times q01's, materialise pairs once and run STEPS 2 to 6 on it:
--     CREATE TEMP TABLE pairs AS SELECT DISTINCT ... (the body of STEP 1);
--   then start the WITH clause at k. Correctness is the same either way.
-- * countries_distinct_count is a ready-made scalar column in the works table
--   (number of distinct author countries). 1 / countries_distinct_count gives
--   the fractional weight without STEP 2; the CTE is kept so the room sees
--   where the weight comes from. TODO check at rehearsal that both agree.
-- * Whole counts across countries add up to more than the number of
--   articles (international papers are counted several times); fractional
--   counts add up to exactly the number of articles with a country. That is
--   the point of showing both.
-- * The API version (leg B2, group_by=authorships.countries) is whole
--   counting only and returns at most 200 groups; here there is no cap.
-- * The result table is a good candidate for materialisation, see q04.
-- ---------------------------------------------------------------------------
