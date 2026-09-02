-- ============================================================================
-- q03_patcit_green.sql  (DAISY 2026, leg C, step C3: science to technology)
--
-- QUESTION (economics terms): does circular-economy (CE) science reach
--   patents, how fast, and in which patent office? For CE articles published
--   2000 to 2016 (with a DOI), the share cited on at least one patent front
--   page (extensive margin) and the mean number of citing patents among the
--   cited (intensive margin), by publication year and by OpenAlex subfield;
--   then the citing office (US, EP, WO, CN, JP, KR ...) and the lag in years
--   between the article and the citing patent publication.
--   The article window stops in 2016 because PatCit's DOCDB front-page data
--   run to 2018: later cohorts have had almost no time to be cited
--   (right-censoring; keep that caveat on the slide).
--
-- TABLES READ:
--   subugoe-collaborative.openalex_walden.works
--   patcit-public-data.frontpage.bibliographical_reference
-- COLUMNS READ:
--   works: id, doi, publication_year, type, is_xpac, primary_topic.id,
--          primary_topic.subfield.display_name
--   PatCit: DOI, cited_by.publication_number, cited_by.publication_date
-- CREATES: arboreal-avatar-477416-i4.daisy.q03_ce_patcit_pairs (one row per
--   CE article x citing patent, uncited articles kept with NULL patent).
--   Steps 2 to 5 read only that small table, so the expensive join runs once.
-- EXPECTED BYTES: TODO record at rehearsal (step 1 only; steps 2 to 5 are MB).
-- EXPECTED RUNTIME: TODO record at rehearsal.
-- STATA EQUIVALENT of the main step:
--   use ce_articles (one row per article, doi_key), merge 1:m doi_key using
--   patcit_pairs (one row per doi x citing patent), keep if _merge != 2;
--   gen cited = _merge == 3; collapse (max) cited (count) n_pat = pubnum,
--   by(id year subfield); then collapse (mean) cited n_pat, by(year).
-- SWITCH TO nber-i3: see the commented block at the end. It swaps PatCit for
--   Reliance on Science (nber-i3.reliance_on_science.pcs_oa_v64), which
--   carries OpenAlex ids, so the join is on the numeric work id, not on DOI.
--
-- PATCIT, WHAT IT IS (fact-checked 18 Aug 2026 against github.com/cverluise/
--   PatCit docs, schema JSONs, Zenodo, Crossref; the same wording as the plan
--   and the slide): open-source project started in 2019 by Gaetan de
--   Rassenfosse (EPFL) and Cyril Verluise (College de France / PSE), with
--   Cristelli, Higham, Violon, Gerotto, Simcoe. Two pillars: (i) FRONT-PAGE
--   citations from DOCDB (EPO bibliographic data, 90+ countries, coverage
--   1836 to 2018), deduplicated and classified into 10 NPL categories
--   (bibliographical reference, office action, patent, search report,
--   litigation, database, product documentation, norms and standards,
--   webpage, wiki) with a spaCy classifier trained on ~3,000 hand-labelled
--   citations; bibliographical references parsed with GROBID and matched with
--   biblio-glutton to CROSSREF and PUBMED (DOI, PMID, PMCID, ISSN);
--   (ii) IN-TEXT citations from the Google Patents USPTO full-text corpus
--   (patent-to-patent and bibliographical references). Latest release
--   v0.3.1, 23 Dec 2020, STATIC since then, Zenodo doi:10.5281/zenodo.4391095
--   (concept doi 10.5281/zenodo.3710993), 16.5 GB, data licence CC BY 4.0,
--   code MIT. BigQuery project patcit-public-data: frontpage.
--   bibliographical_reference (patcit_id, DOI, PMID, PMCID, ISSN, title,
--   journal_title, date INT64 as YYYYMMDD, author, is_cited_by_count, npl_cat,
--   cited_by[] {publication_number e.g. 'US-7650331-B1', publication_date
--   INT64, appln_id, origin, docdb_family_id, inpadoc_family_id}),
--   frontpage.all_meta (patcit_id, npl_cat, cited_by[]), frontpage.wiki,
--   frontpage.norm_standard, frontpage.database, intext.bibliographical_
--   reference, intext.patent. NO OPENALEX IDS INSIDE PATCIT: the join to
--   OpenAlex is on DOI, LOWER(REPLACE(w.doi, 'https://doi.org/', '')) =
--   LOWER(p.DOI). Papers: Verluise, Cristelli, Higham & de Rassenfosse (2026)
--   "Beyond the front page: in-text citations to patents as traces of
--   inventor knowledge", Strategic Management Journal 47(3) 678-698,
--   doi:10.1002/smj.70027 (published version of the 2020 WP "The missing 15
--   percent of patent citations", EPFL STIP WP 13; it is about in-text
--   patent-to-patent citations); dataset citation Verluise, Cristelli, Higham,
--   Violon & de Rassenfosse, "PatCit: A Comprehensive Dataset of Patent
--   Citations", Zenodo. VERSUS RELIANCE ON SCIENCE (Marx & Fuegi 2020 SMJ
--   41(9) 1572-1594 doi:10.1002/smj.3145; 2022 JEMS doi:10.1111/jems.12455):
--   RoS targets patent-to-scientific-article links only (front page worldwide
--   plus in-text USPTO/EPO, confidence score 1 to 10), CC BY-NC 4.0, latest
--   v39 (May 2023), hosted on Zenodo and nber-i3 (reliance_on_science.
--   pcs_oa_v64, with OpenAlex ids); PatCit covers all NPL types plus in-text
--   patent citations, CC BY, DOI/PMID keys, frozen at 2020.
--
-- TODO BEFORE THE DEMO (rehearsal):
--   1. Confirm patcit-public-data still answers queries in 2026 (patcit.io is
--      dead): run block (0) below. Else use nber-i3.reliance_on_science.
--      pcs_oa_v64 (join on oaid = CAST(REGEXP_EXTRACT(w.id, r'W(\d+)') AS
--      INT64)), written out in the commented block at the end.
--   2. Check the DATA LOCATION of subugoe-collaborative.openalex_walden and of
--      patcit-public-data.frontpage (console, dataset "Details" tab).
--      BigQuery cannot join datasets in different locations; if they differ,
--      run the nber-i3 alternative (nber-i3 and patcit-public-data have been
--      joined before in cbe_sci/regpat_CBEtag_new_NPLtag.sql) and create the
--      daisy dataset in the same location as the sources.
--   3. Format of cited_by.publication_date: the PatCit schema JSON
--      (frontpage_bibref.json, read 18 Aug 2026) declares it INTEGER and
--      describes it as "The publication date (yyyymmdd)", so 20150312 is
--      expected and the SUBSTR(...,1,4) cast below is right (it also works
--      for a bare year and returns NULL otherwise). Block (0) prints five
--      values: glance at them once to confirm.
--   4. Record the DOI match rate (block 2, first row) and spot-check five
--      known CE papers with patent citations (block 6, fill the DOIs).
-- ============================================================================


-- ---------------------------------------------------------------------------
-- (0) LIVENESS AND FORMAT CHECK, cheap (one small table read with LIMIT;
--     the estimate is small because bibliographical_reference is a few GB).
--     TODO record at rehearsal: does it run, and what publication_date looks like.
-- ---------------------------------------------------------------------------
SELECT
  p.DOI,                                           -- Crossref DOI, bare form '10.xxxx/...'
  p.is_cited_by_count,                             -- number of citing patents (PatCit's own count)
  cb.publication_number,                           -- citing patent, e.g. 'US-7650331-B1'
  cb.publication_date,                             -- INT64, expected YYYYMMDD
  cb.origin                                        -- source of the citation record
FROM `patcit-public-data.frontpage.bibliographical_reference` AS p,   -- PatCit front-page references
  UNNEST(p.cited_by) AS cb                         -- one row per citing patent
WHERE p.DOI IS NOT NULL                            -- only references matched to a DOI
LIMIT 5;                                           -- five rows are enough to see the formats


-- ---------------------------------------------------------------------------
-- (1) BUILD THE PAIRS TABLE: one row per CE article (2000 to 2016, with DOI)
--     x citing patent, LEFT JOIN so uncited articles stay with NULL patent.
--     Needs a dataset you own: `arboreal-avatar-477416-i4.daisy` (create it
--     once with q04 step 0, same location as the sources). No own dataset?
--     Change "CREATE OR REPLACE TABLE `...` AS" to "CREATE TEMP TABLE
--     q03_ce_patcit_pairs AS", replace the table name in steps 2 to 6 by
--     q03_ce_patcit_pairs, and run the whole file as one script.
--     TODO record at rehearsal: bytes, runtime, rows.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE TABLE `arboreal-avatar-477416-i4.daisy.q03_ce_patcit_pairs` AS

-- STEP 1a: CE topic set (same list as q01/q02).
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

-- STEP 1b: CE articles 2000 to 2016 with a DOI, and the DOI in the bare
--   lower-case form PatCit uses ('10.1016/j.jclepro...' instead of
--   'https://doi.org/10.1016/J.JCLEPRO...'). (Stata: keep if ..., gen
--   doi_key = lower(subinstr(doi, "https://doi.org/", "", 1)))
ce AS (
  SELECT
    w.id,                                                            -- work id
    w.publication_year,                                              -- year
    w.primary_topic.subfield.display_name AS subfield,               -- OpenAlex subfield label
    LOWER(REPLACE(w.doi, 'https://doi.org/', '')) AS doi_key         -- join key
  FROM `subugoe-collaborative.openalex_walden.works` AS w
  WHERE w.type = 'article'                                           -- journal articles only
    AND NOT w.is_xpac                                                -- core corpus
    AND w.publication_year BETWEEN 2000 AND 2016                     -- cohorts with time to be cited
    AND w.doi IS NOT NULL                                            -- PatCit is keyed on DOI
    AND w.primary_topic.id IN (SELECT id FROM green)                 -- CE primary topic
),

-- STEP 1c: PatCit front-page references matched to a DOI, exploded to one
--   row per (DOI, citing patent). DISTINCT because the same DOI can sit on
--   several PatCit rows (imperfect deduplication) and a patent could cite
--   it twice. PatCit's DOI column should hold bare Crossref DOIs; the
--   REGEXP_REPLACE strips a "https://doi.org/" or "http://dx.doi.org/"
--   prefix in case some rows carry one (cheap insurance, no effect otherwise).
pat AS (
  SELECT DISTINCT
    REGEXP_REPLACE(LOWER(p.DOI), r'^https?://(dx\.)?doi\.org/', '') AS doi_key,   -- join key, bare lower-case DOI
    cb.publication_number,                                           -- citing patent, 'US-7650331-B1'
    cb.publication_date                                              -- INT64, expected YYYYMMDD
  FROM `patcit-public-data.frontpage.bibliographical_reference` AS p,   -- PatCit front-page references
    UNNEST(p.cited_by) AS cb                                         -- one row per citing patent
  WHERE p.DOI IS NOT NULL                                            -- only DOI-matched references
)

-- STEP 1d: LEFT JOIN articles to citing patents on the DOI key.
--   (Stata: merge 1:m doi_key using pat, keep(1 3))
SELECT
  c.id,                                                              -- work id
  c.publication_year,                                                -- article year
  c.subfield,                                                        -- article subfield
  c.doi_key,                                                         -- DOI
  pat.publication_number,                                            -- citing patent or NULL
  REGEXP_EXTRACT(pat.publication_number, r'^([A-Z]{2})-') AS office, -- 'US', 'EP', 'WO', 'CN', ...
  SAFE_CAST(SUBSTR(CAST(pat.publication_date AS STRING), 1, 4) AS INT64) AS patent_year,      -- year of the citing patent
  SAFE_CAST(SUBSTR(CAST(pat.publication_date AS STRING), 1, 4) AS INT64) - c.publication_year AS lag_years  -- lag in years (patent year minus article year)
FROM ce AS c                                                         -- the CE articles of STEP 1b
LEFT JOIN pat ON pat.doi_key = c.doi_key;                            -- keep uncited articles


-- ---------------------------------------------------------------------------
-- (2) EXTENSIVE AND INTENSIVE MARGIN BY PUBLICATION YEAR. Reads the small
--     pairs table only. First glance at the DOI match rate: n_cited / n_articles.
--     TODO record at rehearsal: overall share cited, and the 2016 drop
--     (right-censoring).
-- ---------------------------------------------------------------------------
SELECT
  publication_year,                                                  -- article year
  COUNT(DISTINCT id)                                              AS n_articles,     -- CE articles with DOI
  COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))    AS n_cited,        -- cited by >= 1 patent
  ROUND(100 * COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))          -- cited articles ...
            / COUNT(DISTINCT id), 2)                              AS pct_cited,      -- ... over all articles: extensive margin
  ROUND(COUNT(publication_number)                                                    -- citing patents (pairs) ...
        / NULLIF(COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL)), 0), 2)   -- ... over cited articles (NULLIF avoids /0)
                                                                  AS mean_patents_per_cited_article  -- intensive margin
FROM `arboreal-avatar-477416-i4.daisy.q03_ce_patcit_pairs`         -- the pairs table of block (1)
GROUP BY publication_year                                            -- collapse by year
ORDER BY publication_year;                                           -- chronological output


-- ---------------------------------------------------------------------------
-- (3) THE SAME BY OPENALEX SUBFIELD (which corner of CE science patents draw
--     on: engineering and materials subfields vs management and policy ones).
-- ---------------------------------------------------------------------------
SELECT
  subfield,                                                          -- primary_topic.subfield.display_name
  COUNT(DISTINCT id)                                              AS n_articles,     -- CE articles with DOI
  COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))    AS n_cited,        -- cited by >= 1 patent
  ROUND(100 * COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))          -- cited articles ...
            / COUNT(DISTINCT id), 2)                              AS pct_cited,      -- ... over all articles: extensive margin
  ROUND(COUNT(publication_number)                                                    -- citing patents (pairs) ...
        / NULLIF(COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL)), 0), 2)   -- ... over cited articles
                                                                  AS mean_patents_per_cited_article  -- intensive margin
FROM `arboreal-avatar-477416-i4.daisy.q03_ce_patcit_pairs`         -- the pairs table of block (1)
GROUP BY subfield                                                    -- collapse by subfield
ORDER BY n_articles DESC;                                            -- largest subfields first


-- ---------------------------------------------------------------------------
-- (4) CITING OFFICE AND LAG. office = the two-letter prefix of the DOCDB
--     publication number (US, EP, WO, CN, JP, KR, DE ...). Median lag from
--     APPROX_QUANTILES (percentile 50 of 100 buckets).
-- ---------------------------------------------------------------------------
SELECT
  office,                                                            -- patent office / authority
  COUNT(*)                                        AS n_citations,    -- article x patent pairs
  COUNT(DISTINCT publication_number)              AS n_patents,      -- distinct citing patents
  COUNT(DISTINCT id)                              AS n_articles_cited,   -- distinct cited CE articles
  ROUND(AVG(lag_years), 2)                        AS mean_lag_years, -- mean lag
  APPROX_QUANTILES(lag_years, 100)[OFFSET(50)]    AS median_lag_years    -- median lag
FROM `arboreal-avatar-477416-i4.daisy.q03_ce_patcit_pairs`         -- the pairs table of block (1)
WHERE publication_number IS NOT NULL                                 -- cited pairs only
GROUP BY office                                                      -- collapse by office
ORDER BY n_citations DESC;                                           -- most citing office first


-- ---------------------------------------------------------------------------
-- (5) LAG DISTRIBUTION (histogram input): number of citing patents by lag.
--     Negative lags exist (patent published before the article: pre-prints,
--     DOCDB date quirks); show them, do not hide them.
-- ---------------------------------------------------------------------------
SELECT
  lag_years,                                                         -- patent year minus article year
  COUNT(*) AS n_citations                                            -- pairs at that lag
FROM `arboreal-avatar-477416-i4.daisy.q03_ce_patcit_pairs`         -- the pairs table of block (1)
WHERE publication_number IS NOT NULL                                 -- cited pairs only
GROUP BY lag_years                                                   -- collapse by lag
ORDER BY lag_years;                                                  -- from negative to positive lags


-- ---------------------------------------------------------------------------
-- (6) SPOT CHECK: five CE papers known to be cited by patents. TODO fill the
--     five DOIs at rehearsal (bare lower-case form) from Google Patents or
--     Lens; the query must return them with n_patents > 0, else the DOI
--     normalisation is wrong.
-- ---------------------------------------------------------------------------
-- SELECT
--   doi_key,
--   publication_year,
--   COUNT(publication_number) AS n_patents
-- FROM `arboreal-avatar-477416-i4.daisy.q03_ce_patcit_pairs`
-- WHERE doi_key IN (
--   '10.xxxx/todo1', '10.xxxx/todo2', '10.xxxx/todo3', '10.xxxx/todo4', '10.xxxx/todo5'
-- )
-- GROUP BY doi_key, publication_year
-- ORDER BY doi_key;


-- ===========================================================================
-- ALTERNATIVE (commented): RELIANCE ON SCIENCE ON nber-i3 INSTEAD OF PATCIT.
--   Use if patcit-public-data no longer answers, or if the dataset locations
--   differ. pcs_oa_v64 has one row per (patent, cited OpenAlex work) with
--   `patent` = publication number ('US-7650331-B1' style, case as loaded)
--   and `oaid` = numeric OpenAlex work id (INT64), so the join is on the id
--   and does not need a DOI. Article-only links, CC BY-NC, data to 2023.
--   Column names patent and oaid are taken from the user's own
--   cbe_sci/regpat_CBEtag_new_NPLtag.sql; TODO check the remaining columns
--   (confidence score, front page vs in-text flag) in the console before
--   filtering on them. RoS has no patent date: for the lag, join `patent` to
--   patents-public-data.patents.publications (publication_number,
--   publication_date INT64 YYYYMMDD) or to PatentsView on nber-i3.
--   Works table on i3: nber-i3.openalex.works_20260203; TODO check is_xpac.
-- ===========================================================================
-- CREATE OR REPLACE TABLE `arboreal-avatar-477416-i4.daisy.q03_ce_ros_pairs` AS
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
-- ce AS (
--   SELECT
--     w.id,
--     CAST(REGEXP_EXTRACT(w.id, r'W(\d+)') AS INT64) AS oaid,          -- numeric id for the join
--     w.publication_year,
--     w.primary_topic.subfield.display_name AS subfield
--   FROM `nber-i3.openalex.works_20260203` AS w
--   WHERE w.type = 'article'
--     -- AND NOT w.is_xpac                                              -- TODO keep only if the column exists
--     AND w.publication_year BETWEEN 2000 AND 2016
--     AND w.primary_topic.id IN (SELECT id FROM green)
-- ),
-- ros AS (
--   SELECT DISTINCT
--     r.oaid,                                                          -- cited work, numeric id
--     r.patent                                                         -- citing patent number
--   FROM `nber-i3.reliance_on_science.pcs_oa_v64` AS r
-- )
-- SELECT
--   c.id,
--   c.publication_year,
--   c.subfield,
--   ros.patent AS publication_number,
--   UPPER(REGEXP_EXTRACT(ros.patent, r'^([A-Za-z]{2})-')) AS office   -- 'US', 'EP', ...
-- FROM ce AS c
-- LEFT JOIN ros ON ros.oaid = c.oaid;                                  -- keep uncited articles
--
-- Steps 2 to 4 above then run unchanged on q03_ce_ros_pairs (no lag columns).
