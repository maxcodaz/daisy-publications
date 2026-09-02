-- ============================================================================
-- q04_export_examples.sql  (DAISY 2026, leg C, step C4: out of the warehouse)
--
-- QUESTION (economics terms): how does a BigQuery result become a table in a
--   replication package? Materialise the result (CREATE OR REPLACE TABLE), get
--   it out as CSV for Stata, or pull it straight into Colab (Python) or R,
--   and know the five ways to waste money or get wrong numbers.
-- TABLES READ: subugoe-collaborative.openalex_walden.works (via q01)
-- COLUMNS READ: publication_year, type, is_xpac, primary_topic.id
-- CREATES: arboreal-avatar-477416-i4.daisy (dataset, step 0) and
--   arboreal-avatar-477416-i4.daisy.q01_green_by_year (step 1)
-- EXPECTED BYTES: TODO record at rehearsal (same as q01, the CTAS adds nothing).
-- EXPECTED RUNTIME: TODO record at rehearsal.
-- STATA EQUIVALENT of the main step: save q01_green_by_year.dta, replace
--   (step 1); export delimited (step 2); import delimited (step 4).
-- SWITCH TO nber-i3: replace the source table inside step 1 by
--   `nber-i3.openalex.works_20260203` (TODO check is_xpac, q00 block a1);
--   the daisy dataset must then be in the same location as nber-i3.
-- ============================================================================


-- ---------------------------------------------------------------------------
-- STEP 0: A DATASET OF YOUR OWN, once. In the sandbox this is allowed
--   (10 GB storage, tables expire after 60 days unless expiry is removed
--   after upgrading). LOCATION MUST MATCH THE SOURCE: a CREATE TABLE AS
--   SELECT cannot write across regions. TODO at rehearsal: read the "Data
--   location" of subugoe-collaborative.openalex_walden in the console Details
--   tab and put it below ('US', 'EU', 'europe-west3' ...).
--   Students: replace arboreal-avatar-477416-i4 by their own project id.
-- ---------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `arboreal-avatar-477416-i4.daisy`
OPTIONS (                                          -- dataset / table options
  location = 'US',                                 -- TODO set to the source dataset's location
  description = 'DAISY 2026 teaching tables (leg C, BigQuery demo)'
);


-- ---------------------------------------------------------------------------
-- STEP 1: MATERIALISE A RESULT. "CREATE OR REPLACE TABLE ... AS" in front of
--   any SELECT writes the result to a table instead of the screen; the bytes
--   billed are the same as for the SELECT, storage is negligible (a few KB
--   here). Then the demo, the students and the replication package read the
--   small table, not the 510M-row source. This wraps q01 verbatim.
--   (Stata: the collapse followed by save, replace.)
--   TODO record at rehearsal: bytes, runtime; note the expiry date shown in
--   the table Details tab if the project is a sandbox.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE TABLE `arboreal-avatar-477416-i4.daisy.q01_green_by_year`
OPTIONS (                                          -- dataset / table options
  description = 'CE articles vs all articles by year, OpenAlex June 2026 snapshot (subugoe-collaborative.openalex_walden.works), CE = primary_topic in the DAISY CE topic set'
) AS
WITH green AS (                                                      -- CE topic set, as in q01
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
flagged AS (                                                         -- one row per article, CE flag
  SELECT
    w.publication_year,
    w.primary_topic.id IN (SELECT id FROM green) AS is_ce
  FROM `subugoe-collaborative.openalex_walden.works` AS w
  WHERE w.type = 'article'
    AND NOT w.is_xpac
    AND w.publication_year BETWEEN 2000 AND 2025
)
SELECT                                                               -- the same columns as q01, plus provenance
  publication_year,                                                  -- year
  COUNTIF(is_ce)                              AS n_ce_articles,      -- CE articles
  COUNT(*)                                    AS n_all_articles,     -- all articles
  ROUND(100 * COUNTIF(is_ce) / COUNT(*), 3)   AS pct_ce,             -- share in percent
  'subugoe-collaborative.openalex_walden.works, snapshot 2026-06' AS source,  -- provenance column
  CURRENT_DATE()                              AS run_date            -- when the table was built
FROM flagged                                                         -- one row per article
GROUP BY publication_year                                            -- collapse by year
ORDER BY publication_year;                                           -- chronological


-- ---------------------------------------------------------------------------
-- STEP 2: READ IT BACK (free-ish: a few KB) and export.
--   Console route: run the SELECT, then "Save results" > "CSV (local file)"
--   (up to 10 MB to the browser; larger results go via "CSV (Google Drive)"
--   up to 1 GB, or "BigQuery table" then export; TODO confirm the current
--   caps in the menu at rehearsal). Then in Stata:
--   import delimited q01_green_by_year.csv, clear.
--   Bucket route (only if you have a Cloud Storage bucket; the sandbox does
--   not give one): the EXPORT DATA statement below, commented.
-- ---------------------------------------------------------------------------
SELECT *
FROM `arboreal-avatar-477416-i4.daisy.q01_green_by_year`            -- the small table written in STEP 1
ORDER BY publication_year;                                           -- chronological

-- EXPORT DATA
--   OPTIONS (
--     uri = 'gs://YOUR-BUCKET/daisy/q01_green_by_year_*.csv',   -- wildcard is mandatory
--     format = 'CSV',
--     overwrite = TRUE,
--     header = TRUE,
--     field_delimiter = ','
--   ) AS
-- SELECT * FROM `arboreal-avatar-477416-i4.daisy.q01_green_by_year`
-- ORDER BY publication_year;


-- ---------------------------------------------------------------------------
-- STEP 3: STRAIGHT INTO COLAB (Python) OR R, no CSV in between.
--   Both snippets authenticate with the Google account that owns the project
--   (the sandbox project works). Bytes are billed to that project.
--
--   Colab, Python (cell 1 authenticates, cell 2 is a magic cell that puts
--   the result in a pandas DataFrame called df):
--
--     from google.colab import auth
--     auth.authenticate_user()                       # opens the Google login popup
--     %load_ext google.cloud.bigquery                # enables the %%bigquery magic
--
--     %%bigquery df --project arboreal-avatar-477416-i4
--     SELECT publication_year, n_ce_articles, n_all_articles, pct_ce
--     FROM `arboreal-avatar-477416-i4.daisy.q01_green_by_year`
--     ORDER BY publication_year
--
--     df.plot(x='publication_year', y='pct_ce')       # pandas line chart
--     df.to_csv('q01_green_by_year.csv', index=False) # for Stata: import delimited
--
--   Same thing without the magic (also runs outside Colab):
--
--     from google.cloud import bigquery
--     client = bigquery.Client(project='arboreal-avatar-477416-i4')
--     df = client.query(open('q01_green_by_year.sql').read()).to_dataframe()
--
--   Dry run from Python, to read the bytes before paying:
--
--     job = client.query(sql, job_config=bigquery.QueryJobConfig(dry_run=True))
--     print(job.total_bytes_processed / 1e9, 'GB')
--
--   R, bigrquery (works in Colab's R runtime and in RStudio):
--
--     install.packages("bigrquery")                  # once
--     library(bigrquery)
--     bq_auth()                                      # Google login (Colab: use_oob = TRUE)
--     sql <- "SELECT publication_year, n_ce_articles, n_all_articles, pct_ce
--             FROM `arboreal-avatar-477416-i4.daisy.q01_green_by_year`
--             ORDER BY publication_year"
--     tb <- bq_project_query("arboreal-avatar-477416-i4", sql)   # runs the job
--     df <- bq_table_download(tb)                    # data.frame
--     write.csv(df, "q01_green_by_year.csv", row.names = FALSE)  # for Stata
--
--   Stata itself has no native BigQuery driver; the CSV (or a Python call
--   through Stata's python integration) is the practical path.
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- STEP 4: PITFALLS (the slide "five ways to burn the free terabyte")
--
--   1. SELECT *: bills every column of every row. Name columns; nested
--      records are billed by the leaves you touch (authorships.countries is
--      cheap, authorships is not). Read the estimate at the top right of the
--      editor before every run; it is free.
--   2. LIMIT does not reduce bytes. LIMIT 5 on works still reads the full
--      columns over 510M rows. Use the table's Preview tab (free) to look at
--      rows, and INFORMATION_SCHEMA / __TABLES__ (free) to look at schema
--      and size.
--   3. Cache: an identical query text re-run within 24 hours is served from
--      cache at zero cost (the job page says "cached"). Change one character
--      and you pay again. During the demo, run each query once at rehearsal
--      so the live run is instant and free.
--   4. Join explosion: FROM works, UNNEST(authorships), UNNEST(countries)
--      multiplies rows (5 authors x 2 countries = 10 rows per paper). Count
--      DISTINCT ids, or aggregate back to the paper before joining anything
--      else; joins on exploded tables are where numbers silently double.
--   5. Partition and cluster: check the table Details tab. If a table is
--      partitioned (by date or by an integer range such as publication_year)
--      a WHERE on that column prunes bytes; if it is only clustered, the
--      estimate is an upper bound and the real bill can be lower. Neither
--      helps if you filter on another column. When you materialise your own
--      large table, add PARTITION BY / CLUSTER BY.
--   6. Sandbox expiry: without a billing account, tables, views and
--      partitions expire 60 days after creation. Materialised results for a
--      paper must be exported (CSV, Drive) or the project upgraded (billing
--      on, still 1 TiB free per month; the free tier stays free unless you
--      cross it).
--   7. Reproducibility: name the snapshot in the table description and in
--      the paper (openalex_walden = June 2026 snapshot; nber-i3 tables carry
--      the date in the name, works_20260203). OpenAlex reassigns topics and
--      merges works between snapshots, so counts drift.
-- ---------------------------------------------------------------------------
