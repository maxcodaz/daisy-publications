# DAISY 2026: publications as innovation data

Materials for the two-hour session on publication data at the **DAISY International Summer School** (Data Analytics for Innovation and SustainabilitY), Taranto, 7 to 11 September 2026, taught by Massimiliano Coda Zabetta.

The session pairs theory with a live demonstration. The demonstration shows how the scientific literature can be measured as innovation data, its size, geography, topics and links to patents, with three tools:

| leg | tool | what it shows | folder |
|---|---|---|---|
| A | VOSviewer 1.6.21, querying OpenAlex directly | term map of the circular-economy literature; country co-authorship in climate economics | [vosviewer/](vosviewer/) |
| B | OpenAlex API from a Colab notebook (openalexR, with a pyalex twin) | publication trends, geography, the SDG landscape | [notebooks/](notebooks/) |
| C | BigQuery on the full OpenAlex snapshot, joined to PatCit | the same numbers on the full population, plus the science-to-technology bridge | [sql/](sql/) |

Everything here can be rerun at home after the session. Reproducing the demo takes about ten minutes of setup (OpenAlex API key, VOSviewer, a free BigQuery sandbox, Colab): see [SETUP.md](SETUP.md).

## Contents

- [SETUP.md](SETUP.md): the ten-minute setup guide sent before the school.
- [vosviewer/](vosviewer/): click-path sheets for the three maps shown live, six take-home exercises, and the saved maps in [vosviewer/maps/](vosviewer/maps/) (JSON files that open in VOSviewer or in VOSviewer Online at app.vosviewer.com).
- [notebooks/](notebooks/): the Colab notebooks, one in R (openalexR, the version shown live) and one in Python (pyalex, same cells).
- [sql/](sql/): the five BigQuery scripts, commented line by line, with bytes-scanned estimates in the headers, plus a Colab notebook that takes a result table to a CSV and to a Cloud Storage bucket.
- [data/](data/): `ce_topics.csv`, the circular-economy topic list that the SQL scripts read after you upload it into BigQuery.
- Slides: the PDF is added here after the school.

## Questions

During the school, ask me in person. Before or after it, write me an email.
