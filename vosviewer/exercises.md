# Take-home sheet: six VOSviewer + OpenAlex exercises

Six copy-paste exercises to rerun after the session with VOSviewer 1.6.21 (vosviewer.com/download, Java 8 or later) and the OpenAlex API. They come from the ICE PhD course "Economics of Science", class 4 (slides 21 to 25), with the year filters moved to 2019 to 2025 and one syntax fix. For each: File > Create > choose bibliographic or text data > Download data through API > OpenAlex > paste the request URL. VOSviewer reads only the `search` and `filter` parts of the URL; `page`, `sort` and `per_page` are ignored, so the URLs below carry only the filter. Every URL returns at most 50,000 works, the ceiling of the OpenAlex route. Counts were read from the API on 2 Sept 2026 with keyless calls (`per_page=1`, `meta.count`); they grow a little every week. VOSviewer 1.6.21 has an API key field in the download step: paste the free key from openalex.org/settings/api (see the setup guide). Without it you run on $0.10 per day of keyless credit, which is not enough for exercise 3 (search queries cost ten times a plain filter).

## 1. Co-authorship network of one researcher

- Question: with whom does one researcher publish, and in how many separate groups?
- Filters: author Francesco Quatraro (`A5073659024`); source type journal.
- URL: `https://api.openalex.org/works?filter=authorships.author.id:A5073659024,primary_location.source.type:journal`
- Count: 115 works. No year filter on this one (small set; a range would empty it).
- Map: bibliographic data > co-authorship > unit **Authors** > full counting > minimum documents of an author 2 (or 1 to see everyone) > minimum citations 0.
- Try: switch to fractional counting; overlay by Avg. pub. year to see old and new collaborators. Replace the author id with your own (search yourself at openalex.org, copy the `A...` id from the URL).

## 2. Bibliographic coupling of the papers of three journals

- Question: which papers of Scientometrics, Journal of Informetrics and Quantitative Science Studies share their reference lists, i.e. work on the same problems?
- Filters: sources `S148561398` (Scientometrics), `S205292342` (Journal of Informetrics), `S4210195326` (Quantitative Science Studies).
- URL: `https://api.openalex.org/works?filter=primary_location.source.id:S148561398|S205292342|S4210195326`
- Count: 10,684 works (all years; the class-4 URL had no year filter and none is needed for the cap). To focus on recent work add `,publication_year:2019-2025`.
- Map: bibliographic data > bibliographic coupling > unit **Documents** > full counting > minimum citations of a document 20 (raise it if the map is too dense) > keep the 500 to 1,000 documents with the largest total link strength.
- Try: unit **Sources** (three nodes, not interesting) or **Authors**; overlay by Avg. norm. citations. Note the difference between citation, bibliographic coupling and co-citation (manual footnote 12): with OpenAlex data the wizard supports the first two but not co-citation, because OpenAlex gives reference ids, not reference strings.

## 3. Term co-occurrence map of a set of related publications

- Question: what vocabulary structures a literature, and how does it drift over time?
- Filters: title contains "circular economy"; years 2019 to 2025 (class 4 had 2016 to 2022 and no URL on the slide; this is the reconstructed URL, refreshed).
- URL: `https://api.openalex.org/works?filter=title.search:circular%20economy,publication_year:2019-2025`
- Count: 23,979 works (all types; 24,039 on 18 Aug, counts can also fall a little when OpenAlex merges records). The article-only version used in the DAISY demo, `title.search:circular%20economy,type:article,publication_year:2016-2025`, gives 15,330.
- Map: **text data** > OpenAlex > request URL > title and abstract fields > ignore structured abstract labels and copyright statements > **binary counting** > minimum occurrences 20 to 30 > 60% most relevant terms > untick generic terms > overlay by Avg. pub. year.
- Try: `title.search` vs `title_and_abstract.search` vs `default.search` (the last searches title, abstract and full text where available); the counts differ a lot, the map less than you would think. Try a thesaurus file to merge "circular economy" and "circular economies".

## 4. Topic co-occurrence in the joint publications of two universities

- Question: on which topics do the University of Turin and Politecnico di Torino publish together? Class 4 built this map on OpenAlex **concepts**; concepts are deprecated (frozen), so the unit is now **Topics** (VOSviewer 1.6.21) and, failing that, **Keywords**.
- Filters: works with at least one author at UniTo (`I55143463`, lineage, so departments and hospitals count) **and** at least one at PoliTo (`I177477856`); years 2019 to 2025.
- URL: `https://api.openalex.org/works?filter=authorships.institutions.lineage:I55143463,authorships.institutions.lineage:I177477856,publication_year:2019-2025`
- Count: 1,650 works (3,673 without the year filter).
- Syntax fix, please read: the class-4 URL wrote the AND as `authorships.institutions.lineage:I55143463+I177477856`. On 2 Sept 2026 that URL returned 134,340 works, which is the count for UniTo alone (the second id is dropped), and 52,364 for 2019 to 2025, above the 50,000 cap. Repeating the filter key, as in the URL above, gives the intersection. If you copy a URL from an old slide, check `meta.count` in a browser first.
- Map: bibliographic data > co-occurrence > unit **Topics** (or Keywords) > full counting > minimum occurrences 5 > overlay by Avg. pub. year.
- Try: swap the two ids for your own university and its main partner; try `authorships.institutions.lineage:I55143463|I177477856` (OR) to see the union instead (add years or `type:article` to stay under the cap).

## 5. Co-authorship network of the researchers of one university

- Question: what does the collaboration structure of one university look like, and who are the hubs?
- Filters: institution UniTo (lineage `I55143463`); work type article; source type journal; years 2019 to 2025 (class 4 had 2019 to 2022 and did not put the journal filter in the URL; it is added here as the slide's filter list intended).
- URL: `https://api.openalex.org/works?filter=authorships.institutions.lineage:I55143463,type:article,publication_year:2019-2025,primary_location.source.type:journal`
- Count: 36,358 works, under the cap; if it crosses 50,000 in a later year, narrow the years.
- Map: bibliographic data > co-authorship > unit **Authors** > full counting > "Ignore documents with a large number of authors" on (default 25; UniTo has physics and medicine consortia with hundreds of authors) > minimum documents of an author 10 > minimum citations 0 > keep the largest connected component when asked.
- Try: unit **Organizations** (UniTo's partners), then **Countries**; fractional counting; overlay by Avg. norm. citations. Then take the same URL to the API notebook (`group_by=authorships.institutions.id`) and to BigQuery (`UNNEST(authorships)`), the point of the session being that the three tools answer the same question.

## 6. Bibliographic coupling of the twin-transition literature

- Question: is "twin transition" one research conversation, or two strands (green and digital) sharing a label? Papers that cite the same references work on the same problem; if the corpus splits into clusters with distinct reference bases, the label bundles separate conversations.
- Filters: title contains "twin transition", all years (the phrase barely exists before 2020).
- URL: `https://api.openalex.org/works?filter=title.search:twin%20transition`
- Count: 1,214 works (3 Sept 2026), a small corpus that downloads in seconds.
- Map: bibliographic data > **bibliographic coupling** > unit **Documents** > full counting > minimum citations of a document 0 (the corpus is young) > keep the documents with the largest total link strength; then overlay by Avg. pub. year.
- Try: `title_and_abstract.search:twin%20transition` widens the net to 7,856 works; compare the cluster structure. Then take the same question to the API leg: `group_by=primary_topic.field.id` shows which disciplines the label lives in.

## Two more routes worth knowing

- **DOI file**: any text file with DOIs in it (a Stata export, a Scopus CSV, a reference list) can be given to VOSviewer, which downloads the OpenAlex records for those DOIs and builds any of the maps above. Useful when your sample was built elsewhere.
- **JSON file**: call the API yourself (pyalex, openalexR, curl), save the JSON, and give the file to VOSviewer. Useful for reproducibility (the exact data behind the map are on disk) and for queries the URL route cannot express.

## Counts on 2 Sept 2026 (for your own check)

| ex. | filter | works |
|---|---|---|
| 1 | `authorships.author.id:A5073659024,primary_location.source.type:journal` | 115 |
| 2 | `primary_location.source.id:S148561398\|S205292342\|S4210195326` | 10,684 |
| 3 | `title.search:circular economy,publication_year:2019-2025` | 23,979 |
| 4 | `authorships.institutions.lineage:I55143463,authorships.institutions.lineage:I177477856,publication_year:2019-2025` | 1,650 |
| 4 (old syntax, do not use) | `authorships.institutions.lineage:I55143463+I177477856,publication_year:2019-2025` | 52,364 |
| 5 | `authorships.institutions.lineage:I55143463,type:article,publication_year:2019-2025,primary_location.source.type:journal` | 36,358 |

To recheck a count yourself, open the URL in a browser with `&per_page=1` appended and read `meta.count` in the JSON.
