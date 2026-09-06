-- ============================================================================
-- q03_patcit_green.sql  (DAISY 2026 BigQuery demo, C3: science to patents)
-- CE articles 2000-2016 joined on DOI to the patents citing them on the
-- front page: share cited, by year and by subfield, citing office, lag.
-- Tables: subugoe-collaborative.openalex_walden.works and
-- patcit-public-data.frontpage.bibliographical_reference (both projects
-- starred; the datasets and your daisy dataset must share one location).
-- Writes your-project-id.daisy.q03_ce_patcit_pairs (dataset created in q02
-- STEP 0). your-project-id IS A PLACEHOLDER: replace it everywhere (Ctrl+H)
-- by your own project id.
--
-- PatCit (fact-checked 18 Aug 2026): open-source dataset started in 2019 by
-- Gaetan de Rassenfosse (EPFL) and Cyril Verluise (College de France / PSE).
-- Front-page NPL citations from DOCDB (90+ patent offices), parsed with
-- GROBID, classified into 10 categories, matched to Crossref and PubMed
-- (DOI/PMID keys, no OpenAlex ids: hence the DOI join); plus in-text
-- citations from USPTO full text. Release v0.3.1 (Dec 2020), CC BY 4.0,
-- Zenodo doi:10.5281/zenodo.4391095. Cite: Verluise, Cristelli, Higham &
-- de Rassenfosse (2026), Strategic Management Journal 47(3). Front-page
-- data run to 2018, so the article window stops at 2016 (right-censoring).
-- Its complement, Reliance on Science (Marx & Fuegi 2020, SMJ 41(9)),
-- links patents to scientific articles only, with OpenAlex ids, CC BY-NC.
--
-- Run block (0) first: it checks that patcit-public-data answers and shows
-- the date format.
-- ============================================================================


-- ---------------------------------------------------------------------------
-- (0) LIVENESS AND FORMAT CHECK, cheap: five rows, small table.
-- ---------------------------------------------------------------------------
SELECT
  p.DOI,                                           -- Crossref DOI, bare form '10.xxxx/...'
  p.is_cited_by_count,                             -- number of citing patents (PatCit's own count)
  cb.publication_number,                           -- citing patent, e.g. 'US-7650331-B1'
  cb.publication_date,                             -- INT64, expected YYYYMMDD
  cb.origin                                        -- source of the citation record
FROM `patcit-public-data.frontpage.bibliographical_reference` AS p,
  UNNEST(p.cited_by) AS cb                         -- one row per citing patent
WHERE p.DOI IS NOT NULL                            -- only references matched to a DOI
LIMIT 5;


-- ---------------------------------------------------------------------------
-- (1) BUILD THE PAIRS TABLE: one row per CE article (2000-2016, with DOI)
--     x citing patent; LEFT JOIN keeps uncited articles with NULL patent.
--     Steps 2 to 5 read only this small table, so the big join runs once.
--     No dataset of your own yet? Run q02 STEP 0 first.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE TABLE `your-project-id.daisy.q03_ce_patcit_pairs` AS

-- STEP 1a: CE topic set (same 8 topics as q01/q02).
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

-- STEP 1b: CE articles 2000-2016 with a DOI, the DOI in the bare lower-case
--   form PatCit uses ('10.1016/...' instead of 'https://doi.org/10.1016/...').
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

-- STEP 1c: PatCit references matched to a DOI, exploded to one row per
--   (DOI, citing patent). DISTINCT so each pair counts once; LOWER makes
--   the case match the works-side key.
pat AS (
  SELECT DISTINCT
    LOWER(p.DOI) AS doi_key,                                         -- join key, bare lower-case DOI
    cb.publication_number,                                           -- citing patent, 'US-7650331-B1'
    cb.publication_date                                              -- INT64, expected YYYYMMDD
  FROM `patcit-public-data.frontpage.bibliographical_reference` AS p,
    UNNEST(p.cited_by) AS cb                                         -- one row per citing patent
  WHERE p.DOI IS NOT NULL
)

-- STEP 1d: LEFT JOIN articles to citing patents on the DOI key.
SELECT
  c.id,                                                              -- work id
  c.publication_year,                                                -- article year
  c.subfield,                                                        -- article subfield
  c.doi_key,                                                         -- DOI
  pat.publication_number,                                            -- citing patent or NULL
  REGEXP_EXTRACT(pat.publication_number, r'^([A-Z]{2})-') AS office, -- 'US', 'EP', 'WO', 'CN', ...
  SAFE_CAST(SUBSTR(CAST(pat.publication_date AS STRING), 1, 4) AS INT64) AS patent_year,      -- year of the citing patent
  SAFE_CAST(SUBSTR(CAST(pat.publication_date AS STRING), 1, 4) AS INT64) - c.publication_year AS lag_years  -- lag in years
FROM ce AS c
LEFT JOIN pat ON pat.doi_key = c.doi_key;                            -- keep uncited articles


-- ---------------------------------------------------------------------------
-- (2) EXTENSIVE AND INTENSIVE MARGIN BY PUBLICATION YEAR. Reads only the
--     small pairs table. Expect a drop near 2016: right-censoring.
-- ---------------------------------------------------------------------------
SELECT
  publication_year,                                                  -- article year
  COUNT(DISTINCT id)                                              AS n_articles,     -- CE articles with DOI
  COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))    AS n_cited,        -- cited by >= 1 patent
  ROUND(100 * COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))
            / COUNT(DISTINCT id), 2)                              AS pct_cited,      -- extensive margin
  ROUND(COUNT(publication_number)
        / NULLIF(COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL)), 0), 2)
                                                                  AS mean_patents_per_cited_article  -- intensive margin
FROM `your-project-id.daisy.q03_ce_patcit_pairs`
GROUP BY publication_year
ORDER BY publication_year;


-- ---------------------------------------------------------------------------
-- (3) THE SAME BY OPENALEX SUBFIELD: which corner of CE science patents
--     draw on (engineering and materials vs management and policy).
-- ---------------------------------------------------------------------------
SELECT
  subfield,
  COUNT(DISTINCT id)                                              AS n_articles,
  COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))    AS n_cited,
  ROUND(100 * COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL))
            / COUNT(DISTINCT id), 2)                              AS pct_cited,
  ROUND(COUNT(publication_number)
        / NULLIF(COUNT(DISTINCT IF(publication_number IS NOT NULL, id, NULL)), 0), 2)
                                                                  AS mean_patents_per_cited_article
FROM `your-project-id.daisy.q03_ce_patcit_pairs`
GROUP BY subfield
ORDER BY n_articles DESC;


-- ---------------------------------------------------------------------------
-- (4) CITING OFFICE AND LAG. office = two-letter prefix of the DOCDB
--     publication number. Median from APPROX_QUANTILES (percentile 50).
-- ---------------------------------------------------------------------------
SELECT
  office,                                                            -- patent office / authority
  COUNT(*)                                        AS n_citations,    -- article x patent pairs
  COUNT(DISTINCT publication_number)              AS n_patents,      -- distinct citing patents
  COUNT(DISTINCT id)                              AS n_articles_cited,
  ROUND(AVG(lag_years), 2)                        AS mean_lag_years,
  APPROX_QUANTILES(lag_years, 100)[OFFSET(50)]    AS median_lag_years
FROM `your-project-id.daisy.q03_ce_patcit_pairs`
WHERE publication_number IS NOT NULL                                 -- cited pairs only
GROUP BY office
ORDER BY n_citations DESC;


-- ---------------------------------------------------------------------------
-- (5) LAG DISTRIBUTION (histogram input). Negative lags exist (patent
--     published before the article: preprints, DOCDB date quirks): show
--     them, do not hide them.
-- ---------------------------------------------------------------------------
SELECT
  lag_years,                                                         -- patent year minus article year
  COUNT(*) AS n_citations
FROM `your-project-id.daisy.q03_ce_patcit_pairs`
WHERE publication_number IS NOT NULL
GROUP BY lag_years
ORDER BY lag_years;


-- ---------------------------------------------------------------------------
-- (6) SPOT CHECK (commented): five CE papers known to be cited by patents,
--     bare lower-case DOIs. They must return n_patents > 0, else suspect
--     the DOI normalisation.
-- ---------------------------------------------------------------------------
-- SELECT
--   doi_key,
--   publication_year,
--   COUNT(publication_number) AS n_patents
-- FROM `your-project-id.daisy.q03_ce_patcit_pairs`
-- WHERE doi_key IN (
--   '10.xxxx/todo1', '10.xxxx/todo2', '10.xxxx/todo3', '10.xxxx/todo4', '10.xxxx/todo5'
-- )
-- GROUP BY doi_key, publication_year
-- ORDER BY doi_key;


-- ---------------------------------------------------------------------------
-- (7) OUT OF THE WAREHOUSE. The pairs table doubles as the export demo:
--     * result grid > "Save results": CSV local (~10 MB cap), CSV on
--       Drive (~1 GB), or another BigQuery table; then Stata's
--       import delimited.
--     * bigger tables: EXPORT DATA to a Cloud Storage bucket (the wildcard
--       in the uri is mandatory, exports are sharded; a sandbox has no
--       bucket), or pull straight into Colab / R:
--         Colab:  %%bigquery df --project your-project-id  + the SELECT
--         R:      bigrquery::bq_project_query(), then bq_table_download()
--     * sandbox tables expire after 60 days: export what you want to keep,
--       and name the snapshot in what you export (June 2026 here).
-- ---------------------------------------------------------------------------
