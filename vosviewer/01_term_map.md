# Map 1. Term co-occurrence: "circular economy" in article titles

VOSviewer 1.6.21, text-data route, no code.

## Question

Which vocabularies make up the circular-economy literature, how do they cluster, and which of them are old and which are recent? A term map built from titles and abstracts answers this without any classifier: the structure is estimated from co-occurrence alone.

## Request URL

```
https://api.openalex.org/works?filter=title.search:circular%20economy,type:article,publication_year:2016-2025
```

VOSviewer reads only the `search` and `filter` parameters of the URL and handles paging itself. `title.search` matches the phrase in the title (stemmed, case-insensitive), `type:article` drops reviews, book chapters, preprints and editorials. In September 2026 this returned about **15,300 works** (counts move a little as OpenAlex adds and merges records), well under the 50,000-work ceiling of the OpenAlex route. **11,516 of them (75%) have an abstract in OpenAlex**; the rest contribute their title only (checked with the `has_abstract:true` filter).

The map shown in class was built on the **2021 to 2025** subset of the same query (about 11,950 works, 79% with an abstract) with a minimum of 50 occurrences per term, which gave 637 terms. With the 2016 to 2025 URL and a lower threshold the map is larger and the numbers below change; the structure should not.

## Click path (VOSviewer 1.6.21)

1. Action panel, **File** tab, **Create**.
2. Choose type of data: **Create a map based on text data**. Next.
3. Choose data source: **Download data through API**. Next.
4. Choose API: **OpenAlex**. Next.
5. Choose the **API request URL** option, paste the URL above, and paste your free API key (openalex.org/settings/api) in the **API key** field. Without a key the download runs on the shared keyless allowance of $0.10 per day, which a title-search query of this size exhausts.
6. Next: the download runs.
7. Choose fields: **Title and abstract fields**; tick **Ignore structured abstract labels** and **Ignore copyright statements**.
8. Counting method: **Binary counting** (a term counts once per document, so long abstracts do not dominate).
9. Thesaurus file: leave empty.
10. Threshold: minimum number of occurrences of a term. **50** reproduces the class map on the 2021 to 2025 subset; 20 to 30 gives a denser map.
11. Number of terms: keep the default, the **60% most relevant** (the relevance score removes part of the general vocabulary).
12. Verify selected terms: untick generic survivors ("paper", "study", "data", "literature"), and consider unticking "circular economy" itself, which co-occurs with everything and pulls the whole map to the centre. Finish.
13. Click **Overlay Visualization**; under Scores choose **Avg. pub. year**; via Colors > Set colors range, narrow the range so both ends of the scale are populated (blue is older, yellow is recent). Reduce **Max. lines** if the map is unreadable.

In one line: text data; OpenAlex; request URL; title and abstract fields; ignore labels and copyright statements; binary counting; min. occurrences 50 (or 20 to 30); 60% most relevant terms; overlay by average publication year.

## How to read the map (2021 to 2025 build, 637 terms)

Node size is the number of documents mentioning the term, a link is co-occurrence in the same title or abstract, distance approximates strength of association, and colour is the cluster (network view) or the average publication year (overlay view).

Three clusters carry the map (plus a three-term fragment):

- **Engineering and materials** (252 terms, 61,334 occurrences). The largest node of the whole map is *waste* (2,916 documents), followed by *product* (2,208), *production* (2,160), *application* (1,626), *environmental impact* (913), *energy* (792), *plastic* (481), *life cycle assessment* (375), *food waste* (208). The six strongest links of the map are all inside this cluster (*product-waste* 906, *use-waste* 891, *production-waste* 857).
- **Management and business** (298 terms, 62,865 occurrences): *company* (1,238), *adoption* (1,114), *barrier* (937), *business* (881), *stakeholder* (845), *supply chain* (728), *policymaker* (684), *business model* (617), plus the whole digital vocabulary: *digital technology* (241), *artificial intelligence* (209), *digitalization* (164), *iot* (137), *blockchain* (137), *digital transformation* (98). There is no separate digital cluster: digital terms sit with management, and only *machine learning* (71) sits with the engineers.
- **Policy and economic development** (84 terms, 13,048 occurrences): *enterprise* (466), *european union* (429), *economic development* (289), *ukraine* (175), *environmental protection* (169), *cooperation* (198). It is the oldest cluster (average year 2022.8 against 2023.2 and 2023.5 for the other two) and the least cited (average normalised citations 0.66, against 1.07 and 1.11).

In the overlay by year, the recent end (average year 2024.0 or later) holds *policy framework* (2024.4), *technological advancement*, *sustainability goal*, *waste reduction*, *sustainable practice*, *circular practice*, *ce adoption*, with *policymaker* and *artificial intelligence* just behind; the old end (2022.6 or earlier) holds *covid* (2022.0), *pandemic*, *european commission*, *definition*, *business model*.

Best-cited terms (average normalised citations, at least 50 occurrences): *bioplastic* 3.3, *dynamic capability* 2.3, *manufacturing firm* 2.1, *carbon neutrality* 2.0; the map average is 1.03.

## Caveats

- **Abstract coverage**: 75% of the works have an abstract; coverage is lower for older years and non-English journals, so term frequencies for those groups are underestimated.
- **English only**: term extraction assumes English text; non-English titles produce noise or nothing.
- **A title search is a keyword filter, not a topic**: it misses papers that say "closed-loop" or "industrial symbiosis" without the phrase "circular economy", and catches papers that use the phrase in passing.
- **Noun phrases, longest match**: "artificial neural network" is one term and does not feed "neural network".

## Variations to try

- Swap `title.search` for `title_and_abstract.search` or `default.search`: the counts change a lot.
- Move the relevance cut from 60% to 50% or 70%, or the occurrence threshold from 50 to 20: the periphery changes, the core does not.

## Saved map

[maps/A1_ce_terms_2021_2025.json](maps/A1_ce_terms_2021_2025.json) is the map described above. Download it and open it in VOSviewer (File > Open > VOSviewer JSON file) or in VOSviewer Online (app.vosviewer.com > Open).
