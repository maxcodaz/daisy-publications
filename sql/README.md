# DAISY 2026, leg C: OpenAlex (and PatCit) in BigQuery

BigQuery Standard SQL scripts for the third leg of the live demo ("same question, three tools"): how much circular-economy (CE) science there is, where it is produced, and whether it reaches patents, computed on the full OpenAlex snapshot instead of through the API. The instructor runs them in the BigQuery console; students receive the files and rerun them in their own sandbox after the school.

## Files

| file | step | what it does | tables read |
|---|---|---|---|
| `q00_schema.sql` | C1 | schema of `works` (INFORMATION_SCHEMA, free), row counts and bytes (`__TABLES__`, free), the xpac/core split, a 5-row preview with SQL (to show that LIMIT does not reduce bytes), the "SELECT *" sin | `subugoe-collaborative.openalex_walden.works` |
| `q01_green_by_year.sql` | C2 | CE articles vs all articles by year 2000 to 2025, share; commented variant counting any topic (`topics[]`) instead of the primary one | same |
| `q02_green_by_country.sql` | C2 | CE articles 2015 to 2025 by author country, whole and fractional counting, top 20 plus Italy, RTA | same |
| `q03_patcit_green.sql` | C3 | CE articles 2000 to 2016 joined to PatCit front-page citations on DOI: share cited by patents and citing patents per cited article, by year and by subfield; citing office; lag in years; commented Reliance on Science alternative on `nber-i3` | same + `patcit-public-data.frontpage.bibliographical_reference` |
| `q04_export_examples.sql` | C4 | create the `daisy` dataset, materialise q01 as a table, export to CSV, Colab `%%bigquery` and R `bigrquery` snippets, pitfalls | same |

The CE topic set is inlined in every script as a `WITH green AS (SELECT id FROM UNNEST([...]))` block, so nothing has to be uploaded. The 28 ids in the scripts were pasted on 18 Aug 2026 from `..\data\ce_topic_ids_sql.txt` (the `daisy_group = circular_economy` rows of `..\data\green_topics.csv`), each with its topic name as a trailing comment. If the list changes, rerun `..\_build\paste_ce_ids.py` (it rewrites the block in `q01` to `q04`, including the commented variants) or paste by hand. API cross-check for this set (keyless call, 18 Aug 2026, corpus=core, type:article): 772,022 articles 2000 to 2025.

## How to run

1. Sign in to console.cloud.google.com with any Google account. Without a billing account BigQuery runs in **sandbox** mode: no card, 10 GB of storage, tables expire after 60 days, 1 TiB of query processing per month free, and you can query public datasets in other projects.
2. In the BigQuery Explorer pane click "+ Add" > "Star a project by name" and star `subugoe-collaborative` and `patcit-public-data` (and `nber-i3` for the alternative tables). Starring only makes them visible; it costs nothing.
3. Open a script, paste it in the editor, and read the validator line at the top right: "This query will process X GB when run". That dry-run estimate is free and is the number to compare with the header of each script. If the estimate is far above the header value, stop and look for a `SELECT *` or a missing filter.
4. Run order: `q00` (blocks a1 to a4 are free or almost free; block b costs real bytes, decide whether to run it or only show its estimate), then `q01`, `q02`, `q04` step 0 (creates the `daisy` dataset; needed before `q03` step 1 and `q04` step 1), `q03`, `q04`.
5. Multi-statement files: the console runs the statements one after the other and shows one result tab per statement. To run a single block, select it with the mouse and press Ctrl+Enter (or Cmd+Enter).
6. Rerun the exact same text within 24 hours and BigQuery answers from cache for free (the job page says "cached"). Rehearsal runs therefore make the live runs instant.
7. Students in a sandbox: replace `arboreal-avatar-477416-i4` by your own project id wherever a table is created; everything else runs unchanged.

Dataset locations: BigQuery cannot join or copy across regions. Before the demo check the "Data location" of `subugoe-collaborative.openalex_walden`, `patcit-public-data.frontpage` and (if used) `nber-i3.openalex` in the console Details tab, and create the `daisy` dataset in the same location (`q04` step 0). If `subugoe-collaborative` and `patcit-public-data` sit in different regions, `q03` must run on `nber-i3` (see below).

## Alternative tables on `nber-i3`

`nber-i3` is the i3 BigQuery workspace (Marx & Shvadron 2025); it needs the project starred, no request form. One caveat: the i3 user guide (https://i3open.org/bigquery.html, June 2026, checked 18 Aug 2026) lists a Google Cloud account with billing enabled as a prerequisite, so whether a card-free sandbox project can query `nber-i3` is a rehearsal check; `subugoe-collaborative` and `patcit-public-data` are the sandbox path. Every script has a "SWITCH TO nber-i3" line in its header.

| purpose | subugoe-collaborative (default) | nber-i3 (fallback) |
|---|---|---|
| OpenAlex works | `subugoe-collaborative.openalex_walden.works` (June 2026 snapshot, 510,372,821 rows incl. xpac, column `is_xpac`); legacy `subugoe-collaborative.openalex.works` (Oct 2025, 271M) | `nber-i3.openalex.works_20260203` (also `works_241125`); same nested layout; check whether `is_xpac` exists and drop the filter if not |
| patent to paper citations | `patcit-public-data.frontpage.bibliographical_reference` (PatCit v0.3.1, Dec 2020, DOI keys) | `nber-i3.reliance_on_science.pcs_oa_v64` (Reliance on Science, OpenAlex ids: join on `oaid = CAST(REGEXP_EXTRACT(w.id, r'W(\d+)') AS INT64)`) |
| patent dates and offices | inside PatCit `cited_by[]` (`publication_number`, `publication_date`) | `patents-public-data.patents.publications` (`publication_number`, `publication_date` INT64 YYYYMMDD) or PatentsView tables on `nber-i3` (`patentsview_granted.*_20250317`) |

## Pricing facts (as in the plan, checked 18 Aug 2026)

- On-demand pricing: $6.25 per TiB scanned, first 1 TiB per month per project free (US and EU multi-regions).
- Sandbox: no credit card, 10 GB storage, 60-day expiry of tables, views and partitions, same free TiB, can read public datasets in other projects.
- Free: the dry-run estimate, the table Preview tab, `INFORMATION_SCHEMA` and `__TABLES__`, cached results.
- Not free: `LIMIT n` (full columns are still read), `SELECT *`, any query with a changed character (no cache).
- BigQuery is columnar: cost depends on the leaves you read, not on the number of rows returned. `authorships.countries` is much cheaper than `authorships`.
- Budget for the whole demo: the plan requires all `q0X` scripts together to stay under 500 GB so a sandbox rerun fits in the free TiB. TODO confirm at rehearsal from the recorded estimates.

## TODO at rehearsal (record the values in the script headers)

- [ ] `q00` a3: `row_count` and `size_bytes` of `works` (expect 510,372,821 rows); a4: xpac / core / NULL counts (if `is_xpac` is ever NULL, switch every `NOT is_xpac` to `NOT IFNULL(is_xpac, FALSE)`).
- [ ] `q00` b: bytes estimate of the LIMIT 5 preview; decide whether to run it live or only show the estimate. Check in the Details tab whether `works` is partitioned or clustered.
- [ ] `q00` c: the "SELECT *" estimate (should equal size_bytes).
- [ ] `q01`: bytes, runtime; compare the 2000 to 2025 total with the API cross-check for the same 28 topics (772,022 articles, corpus=core, keyless call of 18 Aug 2026; 11,178 in 2000, 33,711 in 2015, 64,787 in 2025) and with the leg B1 numbers; bytes of the commented `topics[]` variant.
- [ ] `q02`: bytes, runtime; check that `1 / countries_distinct_count` gives the same fractional totals as the CTE; note Italy's rank and RTA for the slide.
- [ ] `q03` block 0: `patcit-public-data` still answers; format of `cited_by.publication_date` (expected INT64 YYYYMMDD; the SUBSTR cast handles YYYYMMDD and bare years). Block 1: bytes, runtime, rows. Block 2: DOI match rate (share of CE articles with at least one citing patent) and the 2016 drop. Block 6: fill five known CE DOIs and confirm they match.
- [ ] Data locations of `subugoe-collaborative.openalex_walden`, `patcit-public-data.frontpage`, `nber-i3.openalex`; set `location` in `q04` step 0 accordingly.
- [ ] `nber-i3.openalex.works_20260203`: does it have `is_xpac`? Columns of `reliance_on_science.pcs_oa_v64` beyond `patent` and `oaid` (confidence score, front page vs in-text) before filtering on them. Also: can a card-free sandbox project query `nber-i3` at all (its user guide asks for billing enabled)?
- [ ] `q04`: current caps of "Save results" > CSV local / Drive; expiry date shown on the sandbox table; run the Colab `%%bigquery` cell and the `bigrquery` snippet once from a throwaway account.
- [ ] If `..\data\ce_topic_ids_sql.txt` changes before the school, rerun `..\_build\paste_ce_ids.py` (idempotent: it rewrites whatever sits between `FROM UNNEST([` and `]) AS id` in `q01` to `q04`, commented variants included).
- [ ] Sum of all recorded estimates < 500 GB.

## References used in the headers

- Marx, M. & Shvadron, D. (2025). The i3 BigQuery Data Workspace: Shared Infrastructure for Open Science. NBER chapter c15344.
- Verluise, C., Cristelli, G., Higham, K. & de Rassenfosse, G. (2026). Beyond the front page: in-text citations to patents as traces of inventor knowledge. Strategic Management Journal 47(3), 678-698. doi:10.1002/smj.70027. PatCit dataset: Zenodo doi:10.5281/zenodo.4391095 (v0.3.1), concept doi:10.5281/zenodo.3710993, CC BY 4.0.
- Marx, M. & Fuegi, A. (2020). Reliance on science: worldwide front-page patent citations to scientific articles. Strategic Management Journal 41(9), 1572-1594. doi:10.1002/smj.3145.
- OpenAlex works schema as loaded by SUB Goettingen: github.com/naustica/openalex (schemas/schema_openalex_work.json). PatCit schema: github.com/cverluise/PatCit (schema/frontpage_bibref.json).
