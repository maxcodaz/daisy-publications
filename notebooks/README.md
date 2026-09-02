# Leg B notebooks: OpenAlex API from Colab

Two notebooks with the same five blocks (B0 anatomy and cost, B1 trend, B2 geography and RTA, B3 SDG landscape, B4 extras). The instructor demos the R one; both are handed to students. Nothing is loaded from disk; every number comes from live API calls (about 25 per run).

| File | Language | Colab runtime | Package | Demoed |
|---|---|---|---|---|
| `daisy_openalex_api_R.ipynb` | R | Runtime > Change runtime type > **R** | openalexR 3.1.0 (CRAN, July 2026) | yes |
| `daisy_openalex_api_python.ipynb` | Python 3 | default | pyalex 0.21 (Feb 2026), pandas, matplotlib | twin, outputs stored |

## Opening in Colab

1. Upload the `.ipynb` to Google Drive (or open it from GitHub / the course page) and open it with Colab.
2. R notebook: menu Runtime > Change runtime type > select **R** > Save. The first cell installs `openalexR` from CRAN (about 20 seconds); dplyr, tidyr and ggplot2 are preinstalled in Colab's R runtime.
3. Python notebook: keep the default Python 3 runtime; the first cell runs `%pip install -U pyalex`.
4. Run cells top to bottom (Runtime > Run all).

## API key and cost

- Since 13 February 2026 OpenAlex expects a key. Free: log in at openalex.org/settings/api and copy the key.
- Budget: 1 USD per day with a free key. A list, filter or group_by call costs 0.0001 USD, a text search 0.001 USD, a single-record lookup nothing. Keyless calls still work with a 0.10 USD daily budget (about 1,000 calls), enough to run either notebook once.
- Where to paste it: R, cell 4, `my_key <- "PASTE-YOUR-KEY"`; Python, cell 4, `API_KEY = "PASTE-YOUR-KEY"`. With the placeholder left in place the notebooks run keyless (the code only registers the key when the placeholder was replaced), so a forgotten key does not break the demo.
- One run of either notebook: about 25 calls, roughly 0.003 USD. Every response carries `meta.cost_usd`; B0 shows it.

## Mapping between the two notebooks

| Block | R (openalexR) | Python (pyalex) | API calls |
|---|---|---|---|
| Setup | `install.packages("openalexR")`, `options(openalexR.apikey = ...)` | `%pip install -U pyalex`, `pyalex.config.api_key = ...` | 0 |
| B0 anatomy | `oa_fetch(entity = "works", identifier = "W1732240353")`, list-columns `topics`, `authorships`, `sustainable_development_goals`; `count_only = TRUE` for the cost line | `Works()["W1732240353"]` (a dict), `pd.DataFrame(paper["topics"])`; `.get(per_page=1).meta` for the cost line | 2 |
| B1 trend | `oa_fetch(..., primary_topic.id = "T10471", publication_year = "2010-2025", group_by = "publication_year")`; the CE ids are joined once into one string `ce_or` (`paste(ce_topics, collapse = "|")`) and passed as the filter value (a character vector would also become an OR list, but openalexR splits vectors longer than 50 into several calls, which would duplicate group_by keys) | `Works().filter(primary_topic={"id": "T10471"}, publication_year="2010-2025").group_by("publication_year").get()`; `"|".join(ce_topics)` for the OR list | 3 |
| B2 countries | `group_by = "authorships.countries"` for the topic set and for all works; RTA with dplyr; ggplot bar chart | same filters; pandas merge; matplotlib barh | 2 |
| B2 Italian regions | two `jsonlite::fromJSON(url)$group_by` calls (see below), `oa_fetch(entity = "institutions", country_code = "IT", options = oa_options(sort = "works_count:desc", per_page = 200, pages = 1))`, `unnest(geo)`, city-to-region lookup | two `.group_by("authorships.institutions.id").get()`, `Institutions().filter(country_code="IT").sort(works_count="desc").get(per_page=200)`, same lookup | 3 |
| B3 SDGs | `group_by = "sustainable_development_goals.id"` for IT and DE; `sustainable_development_goals.id = "https://openalex.org/sdgs/13"` + `group_by = "primary_topic.subfield.id"` | `.filter(authorships={"countries": "IT"}).group_by("sustainable_development_goals.id")`, `.filter(sustainable_development_goals={"id": "https://openalex.org/sdgs/13"})` | 3 to 4 |
| B4 extras | `count_only = TRUE`; `oa_snowball()`; `oa_options(sample = 200, seed = 42, paging = "page")`; `write.csv()`, `haven::write_dta()` | `.count()`; `Works().filter(cites=...)` and `.filter(cited_by=...)`; `.sample(200, seed=42)`; `to_csv()`, `to_stata()` | 5 to 8 |

Circular-economy topic set: both notebooks inline the 28 topic ids of `session/data/ce_topic_ids_api.txt` (names, counts and pruning notes in `session/data/README.md`), the same list that leg C inlines in SQL and leg A pastes in the VOSviewer URL. `_build/build_notebooks.py` reads `data/ce_topic_ids.txt` at build time, so a pruned list only needs a rebuild. Any change to the list changes every B1/B2 number and the stored Python outputs (re-run the notebook).

## Known differences and caveats

- **API vs snapshot.** The API answers from the live Walden data with `corpus=core` by default (the 190 million low-metadata "xpac" records are excluded); the BigQuery table of leg C (`subugoe-collaborative.openalex_walden.works`, June 2026 snapshot) contains them with the flag `is_xpac`. Filter `NOT is_xpac` in SQL to compare with the API; expect residual differences from the snapshot date.
- **group_by cap.** The API returns at most 200 groups per page. `pyalex` `.get()` returns that first page (the 200 largest groups); `openalexR` pages through all groups with `cursor=*` when there are 200 or more. For institutions (thousands of groups) the R notebook therefore reads the URL directly with `jsonlite`, and for `all works by country` the R version has all countries while the Python one has the 200 largest (negligible for the RTA). Leg C has no cap.
- **Institution geo.** On 18 Aug 2026, 130 of the 200 largest Italian institutions have `geo.region = null` (all have a city). Both notebooks patch it with a city-to-region table that covers every city in that list; if new cities appear, the unmatched institutions are dropped and counted in the cell output.
- **Institution counts.** Some Italian institution totals in the June 2026 data look inflated (disambiguation noise); the notebooks say so in the interpret cells. Regional RTAs are illustrative.
- **2025 denominator.** All works in 2025 jump to 15.1 million (10.8 million in 2024) on 18 Aug 2026, which lowers both shares in B1 for that year; check at rehearsal.
- **Numbers on 18 Aug 2026 (28-topic set).** B1: circular-economy share of world output 0.45 percent (2010) to 0.78 (2024); T10471 share 0.053 to 0.046. B2: CE works 2020-2025 CN 78,298, US 33,220, IN 29,040, ID 25,805, BR 16,055, IT 11,521; RTA IT 0.99, DE 0.76, FR 0.73, GB 0.74, US 0.46, CN 1.36, IN 1.38. B3: SDG 3 = 16.9 percent of Italian works, 11.8 of German; Italy SDG 13 top subfields Global and Planetary Change (12 percent), Atmospheric Science (7). B4: 295,333 CE articles 2020-2025. These are the figures to reconcile with leg C.
- **openalexR versions.** Written for 3.1.0 (CRAN). 2.0.0 fails to parse works ("Column name `id` must not be duplicated") and takes `per_page`, `pages`, `paging` as top-level arguments instead of `oa_options()`; the code comments say where. `oa_snowball()` was not run at build time.
- **pyalex versions.** Written for 0.21 (`pyalex.config.api_key`, `.meta` on results). Colab may ship an older pyalex, hence the `%pip install -U`.
- **per_page.** The API accepted `per-page=200` on 18 Aug 2026 (the documented cap was 100 at some point); both packages default to 200.

## Build

`_build/build_notebooks.py` writes both notebooks with nbformat; `_build/execute_python_nb.py` executed the Python one on 18 Aug 2026 (pyalex 0.21, keyless) and stored the outputs; `_build/test_r_*.R` hold the Rscript checks of the R calls (openalexR 3.1.0 installed in a scratch library, plus the local 2.0.0). Verified counts are listed in the last cell of the R notebook.
