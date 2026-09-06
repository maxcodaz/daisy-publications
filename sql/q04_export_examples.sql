-- ============================================================================
-- q04_export_examples.sql  (DAISY 2026 BigQuery demo, take-home: exports)
-- Reference: how a result becomes a file for your paper.
-- your-project-id IS A PLACEHOLDER: replace it everywhere (Ctrl+H) by your
-- own project id.
-- ============================================================================


-- ---------------------------------------------------------------------------
-- (1) MATERIALISE A RESULT. "CREATE OR REPLACE TABLE ... AS" in front of any
--     SELECT writes the result to a table; the bytes billed are the same as
--     for the bare SELECT, storage of a small result is negligible.
--     Example: store q01's result with two provenance columns.
-- ---------------------------------------------------------------------------
-- CREATE OR REPLACE TABLE `your-project-id.daisy.q01_green_by_year` AS
-- <paste the WITH ... SELECT of q01 here, adding to its final SELECT:>
--   'subugoe-collaborative.openalex_walden.works, snapshot 2026-06' AS source,
--   CURRENT_DATE() AS run_date


-- ---------------------------------------------------------------------------
-- (2) SMALL RESULTS OUT. Run a SELECT on the saved table, then the result
--     grid's "Save results": CSV local (~10 MB cap), CSV on Google Drive
--     (~1 GB), or another BigQuery table. Stata: import delimited.
-- ---------------------------------------------------------------------------
-- SELECT * FROM `your-project-id.daisy.q01_green_by_year` ORDER BY publication_year;


-- ---------------------------------------------------------------------------
-- (3) BIG TABLES OUT: EXPORT DATA to a Cloud Storage bucket. The wildcard
--     in the uri is mandatory (large exports are sharded into many files);
--     a sandbox has no bucket, this needs billing enabled.
-- ---------------------------------------------------------------------------
-- EXPORT DATA OPTIONS (
--   uri = 'gs://YOUR-BUCKET/daisy/q03_pairs_*.csv',
--   format = 'CSV', overwrite = TRUE, header = TRUE
-- ) AS
-- SELECT * FROM `your-project-id.daisy.q03_ce_patcit_pairs`;


-- ---------------------------------------------------------------------------
-- (4) STRAIGHT INTO COLAB (Python), no CSV in between. Bytes are billed to
--     the project you name (a sandbox project works). The runnable version,
--     CSV and gsutil copy to a bucket included, is
--     daisy_bigquery_to_bucket.ipynb in this folder.
--
--     from google.colab import auth
--     auth.authenticate_user()                        # Google login popup
--     %load_ext google.cloud.bigquery                 # enables %%bigquery
--
--     %%bigquery df --project your-project-id
--     SELECT * FROM `your-project-id.daisy.q01_green_by_year`
--     ORDER BY publication_year
--
--     df.to_csv('q01_green_by_year.csv', index=False)  # for Stata
--
--     Dry run from Python (read the bytes before paying):
--     job = client.query(sql, job_config=bigquery.QueryJobConfig(dry_run=True))
--     print(job.total_bytes_processed / 1e9, 'GB')
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- (5) R, bigrquery (Colab R runtime or RStudio):
--
--     library(bigrquery)
--     bq_auth()                                       # Google login
--     tb <- bq_project_query("your-project-id",
--           "SELECT * FROM `your-project-id.daisy.q01_green_by_year`")
--     df <- bq_table_download(tb)
--     write.csv(df, "q01_green_by_year.csv", row.names = FALSE)
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- (6) PITFALLS, in one place:
--     * SELECT * bills every column; name what you need (columnar billing).
--     * LIMIT does not reduce bytes; the Preview tab is the free look.
--     * An identical query re-run within 24 hours is cached, free; one
--       changed character and you pay again.
--     * UNNEST multiplies rows (5 authors x 2 countries = 10 rows): count
--       DISTINCT ids or aggregate back before joining anything else.
--     * Sandbox tables expire after 60 days: export what you keep.
--     * Name the snapshot in the paper (openalex_walden = June 2026);
--       OpenAlex reassigns topics and merges works between snapshots.
-- ---------------------------------------------------------------------------
