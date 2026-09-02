# Map 1. Term co-occurrence: "circular economy" in article titles, 2016 to 2025

The first of the three maps shown live in leg A (VOSviewer 1.6.21, text-data route, no code).

## Question

How has the circular-economy research agenda moved over ten years? A term map built from titles and abstracts shows which vocabularies cluster together (waste and recycling, business models and supply chains, life-cycle assessment and materials, digital technologies) and, once coloured by average publication year, which of them are old and which are recent. This is the no-code version of the question the API and BigQuery legs answer with topic ids.

## Request URL

```
https://api.openalex.org/works?filter=title.search:circular%20economy,type:article,publication_year:2016-2025
```

VOSviewer reads only the `search` and `filter` parameters of the URL and handles paging itself, so nothing else is needed. `title.search` matches the phrase in the title (stemmed, case-insensitive), `type:article` drops reviews, book chapters, preprints and editorials, and the year range keeps the map readable. On 2 September 2026 this returned **15,330 works**, well under the 50,000-work ceiling of the OpenAlex route; about 75% of them have an abstract in OpenAlex, the rest contribute their title only.

## Click path (VOSviewer 1.6.21)

1. Action panel, **File** tab, **Create**.
2. Choose type of data: **Create a map based on text data**. Next.
3. Choose data source: **Download data through API**. Next.
4. Choose API: **OpenAlex**. Next.
5. Choose the **API request URL** option and paste the URL above, and paste your free API key (openalex.org/settings/api) in the **API key** field of the download step (present in VOSviewer 1.6.21; older builds lack it). Without a key the download runs on the shared keyless allowance of $0.10 per day, and a title-search query of this size will not finish on it.
6. Next: the download runs (about 150 pages of 100 works).
7. Choose fields: **Title and abstract fields**; tick **Ignore structured abstract labels** and **Ignore copyright statements**.
8. Counting method: **Binary counting** (a term counts once per document, so long abstracts do not dominate).
9. Thesaurus file: none for a first pass (see "variations" below).
10. Threshold: minimum number of occurrences of a term **20** (raise to 30 for a cleaner map).
11. Number of terms: keep the default, the **60% most relevant** (the relevance score removes general vocabulary such as "paper" or "result").
12. Verify selected terms: untick generic survivors ("paper", "study", "article", "literature"), and consider unticking "circular economy" itself: it co-occurs with everything and pulls the whole map to the centre. Finish.
13. Click **Overlay Visualization**; under Scores choose **Avg. pub. year**; via Colors > Set colors range, set roughly 2018 to 2023 so both extremes are visible (blue is older, yellow is recent). Cap **Max. lines** at about 500.

In one line: text data; OpenAlex; request URL; title and abstract fields; ignore labels and copyright statements; binary counting; min. occurrences 20; 60% most relevant terms; overlay by average publication year.

## How to read the map

Node size is the number of documents mentioning the term, a link is co-occurrence in the same title or abstract, distance approximates strength of association, and colour is the cluster (network view) or the average publication year (overlay view). In the overlay, the blue end holds the older waste-and-recycling vocabulary and the yellow end the recent one (digital technologies, AI, plastics, textiles, food waste), which is where the agenda moved after 2020.

## Caveats

- **Abstract coverage**: about 75% of the works have an abstract; coverage is lower for older years and non-English journals, so term frequencies for those groups are underestimated.
- **English only**: term extraction assumes English text; non-English titles produce noise or nothing.
- **A title search is a keyword filter, not a topic**: it misses papers that say "closed-loop" or "industrial symbiosis" without the phrase "circular economy", and catches papers that use the phrase in passing. The API and BigQuery legs use OpenAlex topic ids instead; the two sets overlap but differ, and should.
- **Noun phrases, longest match**: "artificial neural network" is one term and does not feed "neural network".

## Variations to try

- A thesaurus file (two columns: `label`, `replace by`) merges variants such as "circular economy" and "circular economies", or blanks out terms you want ignored.
- Swap `title.search` for `title_and_abstract.search` or `default.search`: the counts change a lot, the map structure less than you would expect.
- Move the relevance cut from 60% to 50% or 70%: the periphery changes, the core does not.

The saved map (`maps/A1_ce_terms_2016_2025.json`) opens in VOSviewer Online: app.vosviewer.com > Open.
