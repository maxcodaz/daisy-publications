# DAISY 2026: publications as innovation data

Materials for the two-hour session on publication data at the **DAISY International Summer School** (Data Analytics for Innovation and SustainabilitY), Taranto, 7 to 11 September 2026, taught by Massimiliano Coda Zabetta. A companion repository from the school is [daisy-networks](https://github.com/ffusillo/daisy-networks) (Fabrizio Fusillo, network analysis).

The session pairs one hour of theory (why economists use publication data, what OpenAlex is, how green science is measured, how science reaches patents) with one hour of live demonstration built around a single question: **how much circular-economy and green science is there, where, by whom, and does it reach patents?** The same question is answered three times with three tools, moving from no code to SQL:

| leg | tool | what it shows | folder |
|---|---|---|---|
| A | VOSviewer 1.6.21, querying OpenAlex directly | term map of the circular-economy literature; country co-authorship in climate economics | [vosviewer/](vosviewer/) |
| B | OpenAlex API from a Colab notebook (openalexR, with a pyalex twin) | publication trends, geography, the SDG landscape | [notebooks/](notebooks/) |
| C | BigQuery on the full OpenAlex snapshot, joined to PatCit | the same numbers on the full population, plus the science-to-technology bridge | [sql/](sql/) |

During the session you watch; everything here can be rerun at home afterwards. Reproducing the demo takes about ten minutes of setup (OpenAlex API key, VOSviewer, a free BigQuery sandbox, Colab): see [SETUP.md](SETUP.md).

## Contents

- [SETUP.md](SETUP.md): the ten-minute setup guide sent before the school.
- [vosviewer/](vosviewer/): click-path sheets for the three maps shown live, six take-home exercises.
- [notebooks/](notebooks/): the Colab notebooks, one in R (openalexR, the version shown live) and one in Python (pyalex, same cells).
- [sql/](sql/): the five BigQuery scripts, commented line by line, with bytes-scanned estimates in the headers.
- [data/](data/): the green and circular-economy topic lists used across all three legs, with provenance notes.
- [readings/](readings/): the reading list with DOIs.
- Slides: the PDF is added here after the school.

## Contact

Massimiliano Coda Zabetta. Questions during the school are welcome in person; afterwards, open an issue here.
