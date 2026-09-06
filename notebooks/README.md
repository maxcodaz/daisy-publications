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
