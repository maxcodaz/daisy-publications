# OpenAlex API from Colab

Two notebooks with the same four blocks (B0 anatomy of a work record and cost, B1 trend, B2 geography and RTA, B3 SDG landscape and priorities), one in R and one in Python: same calls, same numbers. Nothing is loaded from disk; every number comes from live API calls (about 320 per run, almost all of them the two uncapped institution downloads of B2, which take a few minutes).

| File | Language | Colab runtime | Package | Outputs stored |
|---|---|---|---|---|
| `daisy_openalex_api_R.ipynb` | R | Runtime > Change runtime type > **R** | openalexR 3.1.0 (CRAN) | no |
| `daisy_openalex_api_python.ipynb` | Python 3 | default | pyalex 0.21, pandas, matplotlib | yes |

## Opening in Colab

1. Upload the `.ipynb` to Google Drive (or open it from GitHub / the course page) and open it with Colab.
2. R notebook: the kernel metadata declares R, so Colab should pick the R runtime by itself; verify under Runtime > Change runtime type. The first cell installs `openalexR` from CRAN (about 20 seconds); dplyr, tidyr and ggplot2 are preinstalled in Colab's R runtime.
3. Python notebook: keep the default Python 3 runtime; the first cell runs `%pip install -U pyalex`.
4. Run cells top to bottom (Runtime > Run all).

## API key and cost

- OpenAlex expects an API key. It is free: log in at openalex.org/settings/api and copy the key.
- Budget: 1 USD per day with a free key. A list, filter or group_by call costs 0.0001 USD, a text search 0.001 USD, a single-record lookup nothing. Keyless calls still work with a 0.10 USD daily budget (about 1,000 calls), enough to run either notebook once.
- Where to paste it: both notebooks have a `YOUR_API_KEY <- ""` / `YOUR_API_KEY = ""` line in the setup cell. Left empty, the notebooks run keyless, so a forgotten key does not break anything.
- One run of either notebook: about 320 calls (each page of 200 institution groups is one call), roughly 0.03 USD; keyless still fits one full run. Every response carries `meta.cost_usd`; B0 shows it.
