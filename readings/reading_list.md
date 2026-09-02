# Reading list: "Publications as innovation data: measuring (green) science with OpenAlex, at scale with BigQuery"

DAISY International Summer School, Taranto, 7 to 11 September 2026. Session by Massimiliano Coda Zabetta.

How this list was built. Every journal article was resolved on 18 August 2026 through the Crossref API (`https://api.crossref.org/works/<doi>`); authors, year, title, container, volume, issue and pages below are copied from the Crossref record. arXiv items were checked on the arXiv abstract page, reports on the publisher's landing page or repository record, on-disk PDFs on their first page. Each entry carries a "verified" stamp with the source used. Anything that could not be fully checked is not here; it sits in `references_to_check.md` with what is missing. Local copies of the open-access items are in `pdf\` (see `README.md` for the file list).

Nothing here is compulsory. The five core readings are enough to follow the session; the rest is a map for the week after.

---

## 1. Core readings (five)

1. **Priem, J., Piwowar, H., & Orr, R. (2022).** OpenAlex: A fully-open index of scholarly works, authors, venues, institutions, and concepts. arXiv:2205.01833 (v1 4 May 2022, v2 17 June 2022; submitted to STI 2022). https://arxiv.org/abs/2205.01833
   Why: the data source used in all three legs of the practical; also the citation OpenAlex asks for (help.openalex.org/how-to/citing-openalex). Verified 2026-08-18 (arXiv abs page; OpenAlex "citing OpenAlex" page).

2. **Confraria, H., Ciarli, T., & Noyons, E. (2024).** Countries' research priorities in relation to the Sustainable Development Goals. *Research Policy*, 53(3), 104950. https://doi.org/10.1016/j.respol.2023.104950
   Why: the core teaching paper of the theory hour: how to measure what a country's science is about (SDG-related publications, revealed priorities) and what the numbers do and do not say. Verified 2026-08-18 (Crossref).

3. **Kashnitsky, Y., Roberge, G., Mu, J., Kang, K., Wang, W., Vanderfeesten, M., Rivest, M., Chamezopoulos, S., Jaworek, R., Vignes, M., Jayabalasingham, B., Boonen, F., James, C., Doornenbal, M., & Labrosse, I. (2024).** Evaluating approaches to identifying research supporting the United Nations Sustainable Development Goals. *Quantitative Science Studies*, 5(2), 408-425. https://doi.org/10.1162/qss_a_00304
   Why: the "green science" measurement problem in one paper: keyword queries, topic taxonomies and SDG classifiers give different populations, and the choice is a research decision, not a technicality. Verified 2026-08-18 (Crossref).

4. **Marx, M., & Fuegi, A. (2020).** Reliance on science: Worldwide front-page patent citations to scientific articles. *Strategic Management Journal*, 41(9), 1572-1594. https://doi.org/10.1002/smj.3145
   Why: the science-to-technology bridge (patent citations to papers) and the dataset behind the C3 demo alternative on `nber-i3`. Verified 2026-08-18 (Crossref).

5. **Marx, M., & Shvadron, D. (2025).** The i3 BigQuery Data Workspace: Shared Infrastructure for Open Science. NBER chapter c15344, December 2025 draft, in *The Economics of Science: Taking Stock and Looking Ahead* (M. MacGarvie & R. Veugelers, eds.), University of Chicago Press, forthcoming (NBER conference 25-26 September 2025). PDF: https://www.nber.org/system/files/chapters/c15344/c15344.pdf ; chapter page: https://www.nber.org/chapters/c15344 (the page shows the shorter title "The i3 BigQuery Workspace: Shared Infrastructure for Open Science" and a draft date of 27 March 2026; the PDF cover, dated December 2025, is quoted here).
   Why: the argument of leg C (the five challenges of large open datasets, Table 1 of hosted datasets, Listing 1) and the model for the practical hour. Verified 2026-08-18 (NBER chapter page + PDF first page). Local copy: `pdf\marx_shvadron_2025_i3_bigquery_workspace_nber_c15344.pdf`.

---

## The gallery: papers that could not exist without publication data

The six gallery cards of the v2 deck (Part I, slides 4 to 9) and their hinterland. Metadata below was checked in the v2 storyboard citation pass of 18 August 2026 (Crossref DOI resolution; numbers used on the slides were read from the papers or their abstracts the same day). Two flagship papers per card are on the slide; the rest sit in the speaker notes.

Card 1, science to technology (slide 4)
- **Ahmadpoor, M., & Jones, B. F. (2017).** The dual frontier: Patented inventions and prior scientific advance. *Science*, 357(6351), 583-587. https://doi.org/10.1126/science.aam9527
  The distance metric behind the hook and card 1 (80% forward, 61% backward, 6.66 years, 3.72x home runs, modal distance 2-4). Verified 2026-08-18.
- Poege et al. (2019), block 4 below: patents citing higher-quality science are more valuable.

Card 2, funding and the direction of science (slide 5)
- **Azoulay, P., Graff Zivin, J. S., Li, D., & Sampat, B. N. (2019).** Public R&D investments and private-sector patenting: Evidence from NIH funding rules. *Review of Economic Studies*, 86(1), 117-152. https://doi.org/10.1093/restud/rdy034
  The 2.3 net additional private-sector patents per 10 million dollars of NIH funding. Verified 2026-08-18.
- **Myers, K. (2020).** The elasticity of science. *American Economic Journal: Applied Economics*, 12(4), 103-134. https://doi.org/10.1257/app.20180518
  What it costs to redirect scientists to a different question. Verified 2026-08-18.

Card 3, careers and superstars (slide 6)
- **Azoulay, P., Fons-Rosen, C., & Graff Zivin, J. S. (2019).** Does science advance one funeral at a time? *American Economic Review*, 109(8), 2889-2920. https://doi.org/10.1257/aer.20161574
  The funeral effect; the 8.6% on the slide is from the NBER w21788 abstract. Verified 2026-08-18.
- **Hill, R., & Stein, C. (2025).** Scooped! Estimating rewards for priority in science. *Journal of Political Economy*, 133(3), 793-845. https://doi.org/10.1086/733398
  Priority races, priced. Verified 2026-08-18.
- **Hill, R., & Stein, C. (2025).** Race to the bottom: Competition and quality in science. *Quarterly Journal of Economics*, 140(2), 1111-1185. https://doi.org/10.1093/qje/qjaf010
  Competition pushes projects out faster and at lower quality. Verified 2026-08-18.
- **Sinatra, R., Wang, D., Deville, P., Song, C., & Barabási, A.-L. (2016).** Quantifying the evolution of individual scientific impact. *Science*, 354(6312), aaf5239. https://doi.org/10.1126/science.aaf5239
  The random-impact rule, in the slide 6 notes. Verified 2026-08-18.
- **Stern, S. (2004).** Do scientists pay to be scientists? *Management Science*, 50(6), 835-853. https://doi.org/10.1287/mnsc.1040.0241
  Scientists accept lower pay for the freedom to publish; the preference side of the careers card. Verified 2026-08-18.
- **Azoulay, P., Stuart, T., & Wang, Y. (2014).** Matthew: Effect or fable? *Management Science*, 60(1), 92-109. https://doi.org/10.1287/mnsc.2013.1755
  The Matthew effect, tested with prize shocks; cited with the skew pitfall (slide 19). Verified 2026-08-18.
- **Sarsons, H., Gërxhani, K., Reuben, E., & Schram, A. (2021).** Gender differences in recognition for group work. *Journal of Political Economy*, 129(1), 101-147. https://doi.org/10.1086/711401
  Who gets credit inside a byline; needs authorship data by position and gender. Verified 2026-08-18.
- **Borjas, G. J., & Doran, K. B. (2012).** The collapse of the Soviet Union and the productivity of American mathematicians. *Quarterly Journal of Economics*, 127(3), 1143-1203. https://doi.org/10.1093/qje/qjs015
  A supply shock read entirely from publication records. Verified 2026-08-18.

Card 4, teams, novelty, disruption (slide 7)
- **Wuchty, S., Jones, B. F., & Uzzi, B. (2007).** The increasing dominance of teams in production of knowledge. *Science*, 316(5827), 1036-1039. https://doi.org/10.1126/science.1136099
  Team papers had 2.1x the citations of solo papers by 2000 and were 6.3x more likely to pass 1,000 citations. Verified 2026-08-18.
- **Wu, L., Wang, D., & Evans, J. A. (2019).** Large teams develop and small teams disrupt science and technology. *Nature*, 566(7744), 378-382. https://doi.org/10.1038/s41586-019-0941-9
  The CD index by team size; the figure pasted on slide 7. Verified 2026-08-18.
- **Park, M., Leahey, E., & Funk, R. J. (2023).** Papers and patents are becoming less disruptive over time. *Nature*, 613(7942), 138-144. https://doi.org/10.1038/s41586-022-05543-x
  Named on slide 7; its measurement lesson is slide 23. Verified 2026-08-18.
- **Holst, V., Algaba, A., Tori, F., Wenmackers, S., & Ginis, V. (2026).** Dataset artefacts can partially drive the measured decline in disruption. *Nature*, 656, E7-E13. (verified 2026-08-18, Crossref) https://doi.org/10.1038/s41586-026-10787-y
  Zero-reference records carry CD=1 by construction; the decline moves with how they are treated. Volume, pages and DOI verified 2026-08-18; the printed title should be copied from the journal page (see `references_to_check.md`).
- **Park, M., Leahey, E., & Funk, R. J. (2026).** Reply to: Dataset artefacts can partially drive the measured decline in disruption. *Nature*, 656, E14-E21. (verified 2026-08-18, Crossref) https://doi.org/10.1038/s41586-026-10788-x
  The authors defend the result; slide 23 presents the exchange as contested, not settled. Volume, pages and DOI verified 2026-08-18; printed title as above.

Card 5, universities, places, openness (slide 8)
- **Bryan, K. A., & Ozcan, Y. (2021).** The impact of open access mandates on invention. *Review of Economics and Statistics*, 103(5), 954-967. https://doi.org/10.1162/rest_a_00926
  Open access as a treatment on invention. Verified 2026-08-18.
- **Arora, A., Belenzon, S., & Patacconi, A. (2018).** The decline of science in corporate R&D. *Strategic Management Journal*, 39(1), 3-32. https://doi.org/10.1002/smj.2693
  Corporate withdrawal from science, read from publication counts. Verified 2026-08-18.
- **Arora, A., Belenzon, S., Patacconi, A., & Suh, J. (2020).** The changing structure of American innovation: Some cautionary remarks for economic growth. *Innovation Policy and the Economy*, 20, 39-93. https://doi.org/10.1086/705638
  The division of innovative labour. Verified 2026-08-18.
- **Bikard, M., & Marx, M. (2020).** Bridging academia and industry: How geographic hubs connect university science and corporate technology. *Management Science*, 66(8), 3425-3443. https://doi.org/10.1287/mnsc.2019.3385
  Where the two halves meet; in the slide 8 notes. Verified 2026-08-18.

Card 6, green science and the SDGs (slide 9): Confraria, Ciarli & Noyons (2024) and Callaghan et al. (2021) are core readings 2 and block 1 above; Persoon, Bekkers & Alkemade (2020) is in block 4; Coda Zabetta, Quatraro & Scandura (2026) is in block 1.

Not a reading: Toner-Rodgers (2024, arXiv:2412.17866), withdrawn by arXiv administrators on 20 May 2025 after MIT's statement of 16 May 2025; it appears on slide 11 as a provenance caution only (see `references_to_check.md`).

---

## 2. By session block

### Block 1 (0-15 min). Hook, and why economists use publication data

- **Stephan, P. (2012).** *How Economics Shapes Science*. Cambridge, MA: Harvard University Press. ISBN 9780674049710 (print), 9780674062757 (e-book). https://doi.org/10.4159/harvard.9780674062757
  The background book for the whole session (incentives, priority, funding, careers, the "publish" side of the innovation system). Verified 2026-08-18 (Crossref, book record).
- **Hager, S., Schwarz, C., & Waldinger, F. (2024).** Measuring Science: Performance Metrics and the Allocation of Talent. *American Economic Review*, 114(12), 4052-4090. https://doi.org/10.1257/aer.20230515
  What citation metrics do to a labour market once they become visible; the best recent illustration of why measurement choices matter. Verified 2026-08-18 (Crossref). Local copy is the working-paper version dated 9 July 2024 (`pdf\hager_schwarz_waldinger_2024_measuring_science_wp.pdf`; first page checked, same authors and title).
- **Clancy, M. (2022).** Open Science as an Economic Institution. Lecture slides, 8 November 2022, "Economics of Ideas, Science and Innovation" online PhD short course (IFP), 99 slides. Local copy: `pdf\clancy_2022_open_science_economic_institution_lecture.pdf` (first page checked). The current IFP syllabus (https://ifp.org/economics-of-ideas/syllabus, fetched 2026-08-18) lists class 4 under the same title with Pierre Azoulay; the slides on disk are Clancy's 2022 edition. Verified 2026-08-18 (PDF first page; IFP syllabus page).
- **Callaghan, M., Schleussner, C.-F., Nath, S., Lejeune, Q., Knutson, T. R., Reichstein, M., Hansen, G., Theokritoff, E., Andrijevic, M., Brecha, R. J., Hegarty, M., Jones, C., Lee, K., Lucas, A., van Maanen, N., Menke, I., Pfleiderer, P., Yesil, B., & Minx, J. C. (2021).** Machine-learning-based evidence and attribution mapping of 100,000 climate impact studies. *Nature Climate Change*, 11(11), 966-972. https://doi.org/10.1038/s41558-021-01168-6
  The hook figure: what 100,000 papers look like once classified and mapped. Verified 2026-08-18 (Crossref).
- **Coda Zabetta, M., Quatraro, F., & Scandura, A. (2026).** The Geography of Circular Economy Scientific Knowledge in Italy. *Scienze Regionali* (Il Mulino), 2026 special issue (issue "speciale", supplement), 11-37. https://doi.org/10.14650/119816
  The running example of the practical (circular-economy science in Italian regions), done with OpenAlex. Verified 2026-08-18 (mEDRA metadata record for the DOI, api.medra.org/metadata/10.14650/119816: journal Scienze Regionali ISSN 1720-3929, issue "speciale" 2026, pages 11 to 37, three authors, title; the Rivisteweb landing page marks the article open access, check the licence statement before posting the PDF). Local copy: `pdf\coda_zabetta_quatraro_scandura_2026_geography_ce_science_italy.pdf`.
- **Fleming, L., & Sorenson, O. (2004).** Science as a map in technological search. *Strategic Management Journal*, 25(8-9), 909-928. https://doi.org/10.1002/smj.384
  Cited on the "Why do we need publication data" slide (science guides technological search). Verified 2026-08-18 (Crossref).
- **Damioli, G., Bianchini, S., & Ghisetti, C. (2025).** The emergence of a 'twin transition' scientific knowledge base in the European regions. *Regional Studies*, 59(1), 2355998 (online 2024). https://doi.org/10.1080/00343404.2024.2355998
  Green plus digital knowledge in regions, from publications. Verified 2026-08-18 (Crossref). Local copy: `pdf\damioli_bianchini_ghisetti_2025_twin_transition_knowledge_base_regions.pdf` (working-paper version).
- **Bianchini, S., Damioli, G., & Ghisetti, C. (2023).** The environmental effects of the "twin" green and digital transition in European regions. *Environmental and Resource Economics*, 84(4), 877-918. https://doi.org/10.1007/s10640-022-00741-7
  The patent-side twin of the previous paper; useful to see the two proxies side by side. Verified 2026-08-18 (Crossref). Local copy: `pdf\bianchini_damioli_ghisetti_2023_environmental_effects_twin_transition.pdf`.
- **Bianchini, S., Bottero, P., Colagrossi, M., Damioli, G., Ghisetti, C., & Michoud, K. (2023).** Sustainable Development Goals and Digital Technologies: Mapping Scientific Research. JRC Science for Policy Brief, JRC133609, European Commission, Joint Research Centre. https://publications.jrc.ec.europa.eu/repository/handle/JRC133609
  A six-page example of SDG mapping with keyword queries on Web of Science, with fractional counts by country and region. Verified 2026-08-18 (JRC repository record + document's suggested citation). Local copy: `pdf\jrc_2023_bianchini_sdgs_digital_technologies_mapping_research.pdf`.
- **Bello, M., Castellani, D., Damioli, G., Marin, G., Montresor, S., & Ravanos, P. (2025).** What drives twin inventions? Evidence from the EU. JRC143151, EUR 40421, Publications Office of the European Union, Luxembourg. ISBN 978-92-68-31084-7. https://doi.org/10.2760/8255419
  Patent-side counterpart, cited for the "two proxies" slide. Verified 2026-08-18 (JRC repository record + document colophon; the DOI is a Publications Office DOI, not in Crossref). Local copy: `pdf\jrc_2025_bello_what_drives_twin_inventions.pdf`.

### Block 2 (15-28 min). Anatomy of a record and where the data lives

- Priem, Piwowar & Orr (2022), core reading 1.
- **van Eck, N. J. (2023).** Visualizing Science Using OpenAlex and VOSviewer. Slides, OpenAlex how-to webinar, 14 December 2023, CWTS Leiden University, 23 slides. https://openalex.org/Visualizing_Science_Using_OpenAlex_and_VOSviewer.pdf
  Verified 2026-08-18 (PDF first page; the web copy is byte-identical to the on-disk copy, SHA-256 checked). Local copy: `pdf\van_eck_2023_visualizing_science_openalex_vosviewer_slides.pdf`.
- **van Eck, N. J., & Waltman, L. (2010).** Software survey: VOSviewer, a computer program for bibliometric mapping. *Scientometrics*, 84(2), 523-538. https://doi.org/10.1007/s11192-009-0146-3
  The paper to cite for leg A. Verified 2026-08-18 (Crossref).
- **Aria, M., Le, T., Cuccurullo, C., Belfiore, A., & Choe, J. (2024).** openalexR: An R-Tool for Collecting Bibliometric Data from OpenAlex. *The R Journal*, 15(4), 167-180. https://doi.org/10.32614/rj-2023-089
  The paper to cite for leg B (R notebook). Verified 2026-08-18 (Crossref).
- Marx & Shvadron (2025), core reading 5: the "where the data lives" slide and the five challenges.

### Block 3 (28-40 min). Measurement, and the "green science" measurement problem

- Kashnitsky et al. (2024), core reading 3.
- **Ottaviani, M., & Stahlschmidt, S. (2024).** On the performativity of SDG classifications in large bibliometric databases. arXiv:2405.03007 (v1, 5 May 2024). https://arxiv.org/abs/2405.03007 ; https://doi.org/10.48550/arXiv.2405.03007
  Web of Science, Scopus and OpenAlex disagree on which papers are "SDG research". Verified 2026-08-18 (arXiv abs page; no journal version listed there).
- Confraria, Ciarli & Noyons (2024), core reading 2.
- **Ciarli, T. (ed.), Aldoh, A., Arora, S., Arza, V., Asinsten, J., Assa, J., Chataway, J., Colonna, A., Confraria, H., Kombo, P. N., Mittal, N., Mulgan, G., Ndege, N., Noyons, E., Ouma-Mugabe, J., Bhuvana, N., Rafols, I., Steenmans, I., Stirling, A., Sulaiman, R. V., & Yegros, A. (2022).** Changing Directions: Steering science, technology and innovation towards the Sustainable Development Goals. STRINGS project report, SPRU, University of Sussex, 20 October 2022, 148 pp. https://doi.org/10.20919/FSOF1258 ; https://sussex.figshare.com/articles/report/Changing_Directions_Steering_science_technology_and_innovation_towards_the_Sustainable_Development_Goals/23492681
  Verified 2026-08-18 (figshare API record for authors, date, publisher; Crossref for the DOI, which lists Ciarli as editor). Local copies: `pdf\ciarli_2022_strings_changing_directions_full_report.pdf` (full report from figshare) and `pdf\ciarli_2023_strings_policy_brief_un_gsdr.pdf` (the 8-page brief "Steering science, technology and innovation towards the Sustainable Development Goals" hosted at sdgs.un.org, May 2023: https://sdgs.un.org/sites/default/files/2023-05/C8%20-%20Ciarli%20-%20Changing%20Directions%20Steering%20STI%20towards%20the%20SDGs.pdf ).
- **Aristodemou, L., Appelt, S., van Beuzekom, B., & Galindo-Rueda, F. (2025).** Assessing the relevance of R&D funding towards societal goals: Insights from new data sources and AI-assisted methods. *OECD Science, Technology and Industry Working Papers*, No. 2025/25, OECD Publishing, Paris. https://doi.org/10.1787/bafcdc7b-en
  Verified 2026-08-18 (Crossref for authors, title, subtitle, series, year, online 26 Nov 2025; the paper number 2025/25 confirmed the same day on IDEAS/RePEc, handle RePEc:oec:stiaaa:2025/25-en, and EconPapers; the OECD landing page itself returned 403 to the fetcher).
- **Haunschild, R., & Bornmann, L. (2026).** Mapping national and institutional research that targets Sustainable Development Goals using OpenAlex data. *Scientometrics*, 131(7), 4477-4498 (online 12 June 2026). https://doi.org/10.1007/s11192-026-05680-4
  Optional; SDG overlay maps built on OpenAlex. Verified 2026-08-18 (Crossref).
- **Mutz, R., Bornmann, L., & Haunschild, R. (2025).** How to use assignments of United Nations sustainable development goals (SDGs) to scientific papers in research evaluation? The proposal of a gold standard combining assignments from different data providers. *Scientometrics*, 130(3), 1519-1546. https://doi.org/10.1007/s11192-025-05254-w
  Optional; the "combine the classifiers" answer to Kashnitsky et al. Verified 2026-08-18 (Crossref query result).
- **Hicks, D., Wouters, P., Waltman, L., de Rijcke, S., & Rafols, I. (2015).** Bibliometrics: The Leiden Manifesto for research metrics. *Nature*, 520(7548), 429-431. https://doi.org/10.1038/520429a
  The ten principles quoted on the citations slide (indicators support judgement, they never replace it). Verified 2026-08-18 (Crossref).
- **Hirsch, J. E. (2005).** An index to quantify an individual's scientific research output. *Proceedings of the National Academy of Sciences*, 102(46), 16569-16572. https://doi.org/10.1073/pnas.0507655102
  The h-index, cited on the "h-index trap" slide. Verified 2026-08-18 (Crossref).
- Hager, Schwarz & Waldinger (2024), block 1: on citation metrics.

### Block 4 (40-52 min). Science-to-technology bridge (NPL citations)

- Marx & Fuegi (2020), core reading 4.
- **Ahmadpoor, M., & Jones, B. F. (2017).** The dual frontier: Patented inventions and prior scientific advance. *Science*, 357(6351), 583-587. https://doi.org/10.1126/science.aam9527
  The "61% of patents link back to a prior research article" figure on the NPL slide (the abstract states it). Verified 2026-08-18 (Crossref; abstract checked).
- **Bryan, K. A., Ozcan, Y., & Sampat, B. (2020).** In-text patent citations: A user's guide. *Research Policy*, 49(4), 103946. https://doi.org/10.1016/j.respol.2020.103946
  Front-page vs in-text citations, cited on the NPL slide. Verified 2026-08-18 (Crossref).
- **Marx, M., & Fuegi, A. (2022).** Reliance on science by inventors: Hybrid extraction of in-text patent-to-article citations. *Journal of Economics & Management Strategy*, 31(2), 369-392. https://doi.org/10.1111/jems.12455
  Verified 2026-08-18 (Crossref).
- **Popp, D. (2017).** From science to technology: The value of knowledge from different energy research institutions. *Research Policy*, 46(9), 1580-1594. https://doi.org/10.1016/j.respol.2017.07.011 (also NBER WP 22573)
  Verified 2026-08-18 (Crossref).
- **Persoon, P. G. J., Bekkers, R. N. A., & Alkemade, F. (2020).** The science base of renewables. *Technological Forecasting and Social Change*, 158, 120121. https://doi.org/10.1016/j.techfore.2020.120121
  Verified 2026-08-18 (Crossref).
- **Poege, F., Harhoff, D., Gaessler, F., & Baruffaldi, S. (2019).** Science quality and the value of inventions. *Science Advances*, 5(12), eaay7323. https://doi.org/10.1126/sciadv.aay7323
  Verified 2026-08-18 (Crossref).
- **Verluise, C., Cristelli, G., Higham, K., & de Rassenfosse, G. (2026).** Beyond the front page: In-text citations to patents as traces of inventor knowledge. *Strategic Management Journal*, 47(3), 678-698. https://doi.org/10.1002/smj.70027
  Published version of the 2020 working paper below; about in-text patent-to-patent citations, cited for PatCit. Verified 2026-08-18 (Crossref).
- **Verluise, C., Cristelli, G., Higham, K., & de Rassenfosse, G. (2020).** The Missing 15 Percent of Patent Citations. EPFL Innovation and Intellectual Property Policy Working Paper no. 13, December 2020 (also SSRN 3754772). https://cdm-repec.epfl.ch/iip-wpaper/WP13.pdf ; https://ideas.repec.org/p/iip/wpaper/13.html
  Verified 2026-08-18 (PDF first page; the cdm-repec.epfl.ch copy is byte-identical to the local one, the IDEAS page confirms WP no. 13, 62 pp.; the SSRN page 3754772 returned 403 to the fetcher and is quoted from the plan). Local copy: `pdf\verluise_2020_missing_15_percent_wp13.pdf`.
- **de Rassenfosse, G., Kozak, J., & Seliger, F. (2019).** Geocoding of worldwide patent data. *Scientific Data*, 6, 260. https://doi.org/10.1038/s41597-019-0264-6
  Cited on the "where the data lives" slide (hosted on `nber-i3`). Verified 2026-08-18 (Crossref).
- **Masclans, R., Hasan, S., & Cohen, W. M. (2025).** Measuring the commercial potential of science. *Strategic Management Journal*, 46(9), 2199-2236. https://doi.org/10.1002/smj.3720
  Optional; the "commercial potential" dataset listed in Marx & Shvadron's Table 1 (data: "The Commercial Potential of Science", Zenodo record 10815144, v0, 13 March 2024, CC BY-NC 4.0, one file science_compot.csv of 238 MB, https://doi.org/10.5281/zenodo.10815144; the record asks to cite the 2024 NBER working paper). Verified 2026-08-18 (Crossref for the article; Zenodo record page for the dataset).

### Block 5 (52-60 min). Research designs and pointers for the week after

- **REGIS Summer School on Science, Technology and Innovation (2023).** Abstracts and key references, Scuola Superiore Sant'Anna, Pisa. Workshop by Stefano Baruffaldi and Emilio Raiteri, "Scientific Publications Data and Non-Patent Literature Citations" (Scopus + OpenAlex + NPL; its reading list is Marx & Fuegi 2022, Poege et al. 2019, Priem et al. 2022, Rose & Kitchin 2019 pybliometrics, Verluise et al. 2020). Local copy: `pdf\regis_2023_pisa_abstracts_and_references.pdf` (4 pp., text checked 2026-08-18).
- **IFP, "Economics of Ideas, Science and Innovation" online PhD course**, syllabus: https://ifp.org/economics-of-ideas/syllabus (class 4 "Open Science as an Economic Institution", class 5 "The Direction of Science"). Verified 2026-08-18 (page fetched).
- **SciSciNet** (Northwestern CSSI): https://github.com/kellogg-cssi/SciSciNet (MIT licence; v2 built on an OpenAlex snapshot; "45M+ patent linkages" per the docs; BigQuery project `ksm-rch-scisciturbo` on request, Hugging Face and GCS access; docs at https://northwestern-cssi.github.io/sciscinet). Verified 2026-08-18 (GitHub page and docs page).
- **S4 Science of Science Summer School** notebooks: https://github.com/SciSciSummerSchool/s4_lectures (listed in the plan; not re-fetched today).

---

## 3. Tools and data documentation

OpenAlex
- OpenAlex Help Center (the docs; docs.openalex.org now redirects here): https://help.openalex.org/ . Sections: Quickstart, How-to guides, Tutorials, Access, Data, API reference. Verified 2026-08-18.
- How-to guides index: https://help.openalex.org/how-to (searching, counting, API recipes, integrations, citing OpenAlex). Verified 2026-08-18.
- Tutorial used in leg B3, "Map SDG Research": https://help.openalex.org/tutorials/map-sdg-research/ (uses `group_by=sustainable_development_goals.id`). Verified 2026-08-18.
- Access and pricing (API keys, $1 of usage per day on a free account): https://help.openalex.org/access and https://help.openalex.org/access/pricing/ ; per-call figures on https://help.openalex.org/access/example-costs/ (per 1,000 calls: single-entity lookups free, list and filter $0.10, search $1, content download $10; anonymous budget $0.10 per day). Verified 2026-08-18. Free key: https://openalex.org/settings/api (page reachable, login shell).
- Official API tutorials (Jupyter notebooks): https://github.com/ourresearch/openalex-api-tutorials . Verified 2026-08-18.
- pyalex (Python client; `pyalex.config.api_key`): https://github.com/J535D165/pyalex . Verified 2026-08-18.
- openalexR (R client, version 3.1.0.9000 on the docs site; API key via `.Renviron`): https://docs.ropensci.org/openalexR/ ; paper: Aria et al. (2024), block 2. Verified 2026-08-18.

VOSviewer
- Manual for VOSviewer version 1.6.21, Nees Jan van Eck and Ludo Waltman, 12 June 2026, 55 pp.: https://www.vosviewer.com/documentation/Manual_VOSviewer_1.6.21.pdf (§3.5.4 covers OpenAlex). Verified 2026-08-18 (downloaded, first page checked). Local copy: `pdf\vosviewer_manual_1.6.21.pdf`.
- van Eck (2023) webinar slides and van Eck & Waltman (2010), block 2.

BigQuery hosts of publication data
- SUB Göttingen "Open Scholarly Data" overview (project `subugoe-collaborative`; Crossref, Unpaywall, Semantic Scholar, OpenAlex, OpenAlex-Walden, OPENBIB, document-type classification): https://subugoe.github.io/scholcomm_analytics/data.html . Verified 2026-08-18. Loader code: https://github.com/naustica/openalex (target `subugoe-collaborative:openalex.works`; drops mesh, related_works, concepts; `abstract_inverted_index` replaced by `has_abstract`). Verified 2026-08-18. R helper package: https://subugoe.github.io/bqschol/ (from search results, not opened).
- ORION-DBs, catalogue of open research information on BigQuery (subugoe-collaborative, sos-datasources, CWTS Leiden, Dimensions, InSySPo, KB OPENBIB, MultiObs): https://orion-dbs.community/ . Verified 2026-08-18.
- i3 BigQuery workspace (`nber-i3`): Marx & Shvadron (2025), core reading 5. User guide: https://i3open.org/bigquery.html ("i3 BigQuery Data Workspace, User Guide", Dror Shvadron, published June 2026; access by starring `nber-i3`; the guide lists a Google Cloud account with billing enabled as a prerequisite, so whether a card-free sandbox can query it is a rehearsal check). Verified 2026-08-18 (page fetched).

Patent-to-paper citation datasets
- **PatCit** (Verluise, de Rassenfosse et al.). Code and docs: https://github.com/cverluise/PatCit (MIT; docs at https://cverluise.github.io/PatCit/ ; BigQuery project `patcit-public-data`). Data: Verluise, C., Cristelli, G., Higham, K., Violon, L., & de Rassenfosse, G. (2020). *PatCit: A Comprehensive Dataset of Patent Citations*, v0.3.1, 23 December 2020, Zenodo, CC BY 4.0, 16.5 GB. https://doi.org/10.5281/zenodo.4391095 (concept DOI 10.5281/zenodo.3710993). Verified 2026-08-18 (GitHub page + Zenodo record). Whether `patcit-public-data` still answers queries in 2026 is a rehearsal check (plan §6).
- **Reliance on Science** (Marx & Fuegi). Zenodo v39, 31 May 2023: https://doi.org/10.5281/zenodo.7996195 (CC BY-NC 4.0; patent-to-paper citations through 2022, patent-paper pairs through 2021); v37 record https://doi.org/10.5281/zenodo.7497435 ; code https://github.com/mattmarx/reliance_on_science ; catalogue entry https://iiindex.org/datasets/rons/ . On BigQuery as `nber-i3.reliance_on_science.pcs_oa_v64` (from the plan). Verified 2026-08-18 (Zenodo records, iiindex page).

Regional-science and JRC material used for the running example: see block 1 (Coda Zabetta et al. 2026; Damioli et al. 2025; Bianchini et al. 2023; JRC 2023 brief; JRC 2025 report).
