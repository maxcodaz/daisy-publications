# OpenAlex (and PatCit) in BigQuery

BigQuery Standard SQL scripts on the full OpenAlex snapshot: how much circular-economy (CE) science there is, where it is produced, and whether it reaches patents. Every script is commented line by line and runs in a free BigQuery sandbox.

## Files

| file | what it does | tables read |
|---|---|---|
| `q00a_warmup.sql` | four statements of growing size, one clause at a time: COUNT(*) (free), filter + column choice (with a commented `display_name` line to watch the estimate jump), renames/dummy/sort, GROUP BY year | same |
| `q01_green_by_year.sql` | CE articles vs all articles by year 2000 to 2025, share; commented variant counting any topic (`topics[]`) instead of the primary one | same |
| `q02_green_by_country.sql` | CE articles 2015 to 2025 by author country, full and fractional counting, top 20, RCA; step 0 creates the `daisy` dataset and reads the CE topic list from the uploaded `ce_topics.csv` | same + your `daisy.ce_topics` |
| `q03_patcit_green.sql` | CE articles 2000 to 2016 joined to PatCit front-page citations on DOI: share cited by patents and citing patents per cited article, by year and by subfield; citing office with mean and median lag | same + your `daisy.ce_topics` + `patcit-public-data.frontpage.bibliographical_reference` |
| `q04_export_examples.sql` | reference: materialise a result, Save results, EXPORT DATA, Colab `%%bigquery` and R `bigrquery` snippets, pitfalls | same |
| `daisy_bigquery_to_bucket.ipynb` | Colab notebook (Python 3, default runtime, nothing to install): reads a table of your `daisy` dataset (the pairs table written by `q03`) into pandas with `%%bigquery`, writes it to CSV with `astype(str)`, copies the CSV to a Cloud Storage bucket with `gsutil`, every line commented; the bucket step needs billing, sandbox users stop at the CSV | your `daisy.q03_ce_patcit_pairs` |

The CE topic set is the 8 topics returned by the OpenAlex topics search for "circular economy" (`api.openalex.org/topics?search=circular%20economy`); the list with names is in `../data/ce_topics.csv`. It enters the scripts in two ways, on purpose: `q01` inlines it as a `WITH green AS (SELECT id FROM UNNEST([...]))` block so it runs before anything is uploaded, while `q02` and `q03` read it from `daisy.ce_topics`, a table you create by uploading `ce_topics.csv` into your own dataset (`q02` step 0).

## How to run

1. Sign in to console.cloud.google.com/bigquery with a Google account. Without a billing account BigQuery runs in **sandbox** mode: no card, 10 GB of storage, tables expire after 60 days, 1 TiB of query processing per month free, and you can query public datasets in other projects.
2. Nothing has to be starred or added to your project: every script names its tables in full (`subugoe-collaborative.openalex_walden.works`, `patcit-public-data.frontpage...`) and BigQuery resolves them from any project.
3. Open a script, paste it in the editor, and read the validator line at the top right: "This query will process X GB when run". That dry-run estimate is free and is the number to check before every run. If the estimate is far above what the script header announces, stop and look for a `SELECT *` or a missing filter.
4. Suggested order: `q00a`, `q01`, `q02` (its step 0 creates the `daisy` dataset, then upload `ce_topics.csv` with auto-detect off, schema `topic_id_url:STRING,topic_name:STRING`, header rows to skip 1, then the query; auto-detect would name the columns `string_field_0/1` because both are text), `q03` (block 0 first, then blocks 1 to 4; to export the pairs table see `q04`). `q04` is reference material; `daisy_bigquery_to_bucket.ipynb` is the same export as a runnable Colab notebook (open it in Colab, replace `your-project-id`).
5. Multi-statement files: the console runs the statements one after the other and shows one result tab per statement. To run a single block, select it with the mouse and press Ctrl+Enter (or Cmd+Enter).
6. Rerun the exact same text within 24 hours and BigQuery answers from cache for free (the job page says "cached").
7. `q02`, `q03` and `q04` create tables and ship with the placeholder `your-project-id`: replace it everywhere (Ctrl+H) by your own project id (shown in the console's project picker) before running; everything else runs unchanged.

Dataset locations: BigQuery cannot join or copy across regions. Check the "Data location" of `subugoe-collaborative.openalex_walden` and `patcit-public-data.frontpage` in the console Details tab, and create the `daisy` dataset in the same location (`q02` step 0). If the two source datasets sit in different regions, `q03` cannot join them.

## Pricing facts

- On-demand pricing: $6.25 per TiB scanned, first 1 TiB per month per project free (US and EU multi-regions).
- Sandbox: no credit card, 10 GB storage, 60-day expiry of tables, views and partitions, same free TiB, can read public datasets in other projects.
- Free: the dry-run estimate, the table Preview tab, `INFORMATION_SCHEMA` and `__TABLES__`, cached results.
- Not free: `LIMIT n` (full columns are still read), `SELECT *`, any query with a changed character (no cache).
- BigQuery is columnar: cost depends on the leaves you read, not on the number of rows returned. `authorships.countries` is much cheaper than `authorships`.
