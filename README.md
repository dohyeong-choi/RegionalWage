# RegionalWage

Research pipeline for a paper (target: *Journal of Regional Science*, 2027) studying where
young, newly-graduated workers in South Korea choose to locate/work across the 16 sido
(province-level regions), and how large a wage premium a non-Seoul region would need to
offer to compete with Seoul's pull.

## Repo layout

- **`data/`, `images/`, `results/`** are git-ignored and are not real folders in this repo —
  they are **Windows directory junctions** pointing to a shared Google Drive
  (`G:\내 드라이브\RegionalWage\...`). `links.yaml` declares the mapping and `setup_env.py`
  creates the junctions (`mklink /J`) on each collaborator's machine. This is how data is
  shared between coauthors without committing large files to git.
- **`code/`** holds the analysis pipeline, mixing SAS, R, and Python.

### First-time setup

```
python setup_env.py
```

Reads `links.yaml` and creates `data/`, `images/`, `results/` as directory junctions into the
shared Google Drive folder. Run once per machine (Windows only; `mklink /J` may require an
elevated prompt).

No script contains a machine-specific path any more. Python and R locate the repo root by
walking up from the script's own location until they find `links.yaml`, so they can be run
from anywhere. SAS has no equivalent, so it uses `code/00.config.sas` instead — see below.

**SAS only:** submit `code/00.config.sas` once at the start of every SAS session, before
running any other `.sas` file. It defines the macro variables the other programs use:

| Macro | Points to |
|---|---|
| `&PROJ` | repo root |
| `&DATA` | `PROJ\data` (GOMS `.sas7bdat`, `pooled.dta`, the Bartik `.xlsx`) |
| `&RESULTS` | `PROJ\results` |
| `&IMAGES` | `PROJ\images` |
| `&KEUS` | `PROJ\data\지역별고용조사` (regional employment survey CSVs) |

`00.config.sas` derives `&PROJ` automatically from `SAS_EXECFILEPATH` (set by SAS 9.4 DMS,
Enterprise Guide and SAS Studio). If that does not work on your machine, edit the single
fallback `%let PROJ = ...;` line near the top — it is the only hardcoded path left in the repo.

Python dependencies: `pandas`, `numpy`, `openpyxl`, and either `linearmodels` (preferred) or
`statsmodels` (fallback; `02.bartik.py` picks whichever is available and both give the same
first-stage residuals). `07.simul.py` additionally needs `matplotlib`.
R dependencies: `data.table`, `haven`, `logitr`.

## Pipeline (execution order)

0. **`code/00.config.sas`** (SAS sessions only) — submit first; defines `&PROJ` etc.

1. **`code/지역별고용조사/2008.sas … 2020.sas` + `00.취합.sas`**
   Reads raw regional employment survey (지역별고용조사) microdata CSVs for each year from
   `&KEUS`, builds `wage_wide` / `employ_wide` tables per year, then stacks them into
   `wage_panel` / `employ_panel` by year × area (written back to `&KEUS`).

2. **`02.bartik.py`**
   Builds a shift-share (Bartik) instrument for regional wages: leave-one-out same-industry
   employment growth elsewhere × 2011 industry exposure, by sido × industry × age-group ×
   year (2008–2019). Runs a first-stage panel regression (entity FE, industry×year FE,
   age×year FE, convergence controls).
   Reads `data/임금&종사자수(연령구분).xlsx` →
   writes `data/lnwage_external_wage_iv_panel_resid_16sido.xlsx` (level-wage panel +
   IV-residualized wage panel).

3. **`03.2020.sas` / `04.2015.sas`**
   Build individual-level discrete-choice data from GOMS (대졸자직업이동경로조사, graduate
   labor-market survey) microdata for 2015 and 2020: constructs each grad's home region,
   first job region, demographics, and a 16-alternative regional choice set.
   Read `data/GP19__2020.sas7bdat` / `data/GP14_2015.sas7bdat` plus the step-2 xlsx →
   write `lkj.final20` / `lkj.final15` into `data/`.

4. **`05. mlogit.sas`**
   Pools the 2015/2020 datasets, adds year interactions and alternative-specific constants,
   and estimates conditional logit / multinomial probit regional-choice models via
   `PROC MDC`. Exports the pooled dataset to `data/pooled.dta`.

5. **`06.mlogit.R`**
   The main model: a **mixed logit** (random coefficients on wage, "high" [high-school-tie
   region], and "college" [college-tie region]) via `logitr`, simulated with 100 draws / 5
   multistarts.
   Reads `data/pooled.dta` → writes coefficient table, model summary, `.rds` and count files
   to `results/` (tagged `pooled_wages_high_college_draws100_starts5*`).

6. **`07.simul.py`**
   Counterfactual simulation using the mixed-logit coefficients: for each region, finds the
   wage premium (0–100%) needed to make it as attractive as Seoul, separately for 2015/2020
   and under 4 scenarios (actual vs. forcing high-school-tie and/or college-tie to be Seoul)
   — decomposing how much of Seoul's draw is pure wages vs. school-network effects.
   Reads `data/pooled.dta` + the step-5 coefficient CSV from `results/` →
   writes `premium_table_scn{1..4}_*.xlsx` to `results/` and
   `curves_scn{1..4}_*_{2015,2020}.png` to `images/`.
