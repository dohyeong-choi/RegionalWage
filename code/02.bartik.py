import pandas as pd
import numpy as np
from pathlib import Path

try:
    from linearmodels.panel import PanelOLS
    HAS_LINEARMODELS = True
except ImportError:
    import statsmodels.formula.api as smf
    HAS_LINEARMODELS = False


# ============================================================
# 0. 기본 설정
# ============================================================

try:
    BASE_DIR = Path(__file__).resolve().parent
except NameError:
    BASE_DIR = Path.cwd()

INPUT_FILE = BASE_DIR / "임금&종사자수(연령구분).xlsx"

# 기존 파일명 그대로 덮어쓰기
OUTPUT_FILE = BASE_DIR / "lnwage_external_wage_iv_panel_resid_16sido.xlsx"

WAGE_SHEET = "wage"
EMPLOY_WAGE_WEIGHT_SHEET = "employ"
EMPLOY_BARTIK_SHEET = "employ3"

BASE_YEAR = 2008
DATA_START_YEAR = 2008
DATA_END_YEAR = 2019

MODEL_START_YEAR = 2008
MODEL_END_YEAR = 2019

DEP_VAR = "wage"

DROP_JOBS = ["a", "b"]

MIN_VALID_WAGE = 0
MIN_VALID_WEIGHT = 0

# 코멘트에서 말한 "로그 LOO 전국성장"을 기본으로 사용
USE_LOG_EMP_GROWTH = True

# 클러스터 단위: "region" 또는 "unit"
CLUSTER_LEVEL = "region"


# ============================================================
# 1. 시도 코드 설정
# ============================================================

SIDO_ORDER = [
    11,  # 서울
    21,  # 부산
    22,  # 대구
    23,  # 인천
    24,  # 광주
    25,  # 대전
    26,  # 울산
    31,  # 경기
    32,  # 강원
    33,  # 충북
    34,  # 충남세종
    35,  # 전북
    36,  # 전남
    37,  # 경북
    38,  # 경남
    39,  # 제주
]

SIDO_NAME = {
    11: "seoul",
    21: "busan",
    22: "daegu",
    23: "incheon",
    24: "gwangju",
    25: "daejeon",
    26: "ulsan",
    31: "gyeonggi",
    32: "gangwon",
    33: "chungbuk",
    34: "chungnam_sejong",
    35: "jeonbuk",
    36: "jeonnam",
    37: "gyeongbuk",
    38: "gyeongnam",
    39: "jeju",
}

SIDO_NAME_KR = {
    11: "서울",
    21: "부산",
    22: "대구",
    23: "인천",
    24: "광주",
    25: "대전",
    26: "울산",
    31: "경기",
    32: "강원",
    33: "충북",
    34: "충남세종",
    35: "전북",
    36: "전남",
    37: "경북",
    38: "경남",
    39: "제주",
}

REGION_NAME_TO_CODE = {
    "서울": 11,
    "부산": 21,
    "대구": 22,
    "인천": 23,
    "광주": 24,
    "대전": 25,
    "울산": 26,
    "세종": 29,
    "경기": 31,
    "강원": 32,
    "충북": 33,
    "충남": 34,
    "전북": 35,
    "전남": 36,
    "경북": 37,
    "경남": 38,
    "제주": 39,
}

ALT_ID = {code: i + 1 for i, code in enumerate(SIDO_ORDER)}


def normalize_sido(area1):
    area1 = int(area1)
    if area1 == 29:
        return 34
    return area1


def clean_region_name(x):
    return (
        str(x)
        .replace("\u00a0", "")
        .replace(" ", "")
        .strip()
    )


def add_sido_labels(df):
    df = df.copy()
    df["sido"] = df["sido_code"].map(SIDO_NAME)
    df["sido_kr"] = df["sido_code"].map(SIDO_NAME_KR)
    df["name2"] = df["sido_code"].map(ALT_ID)
    return df


def to_num(x):
    return pd.to_numeric(
        x.astype(str)
        .str.replace(",", "", regex=False)
        .str.replace(" ", "", regex=False)
        .str.replace("\u00a0", "", regex=False)
        .replace({
            ".": np.nan,
            "-": np.nan,
            "": np.nan,
            "nan": np.nan,
            "None": np.nan,
            "NaN": np.nan,
        }),
        errors="coerce",
    )


def prep_base_df(df, sheet_name_for_log=""):
    df = df.copy()

    # name 컬럼이 없는 시트(wage/employ: area1로만 식별)도 처리
    if "name" in df.columns:
        df["name_clean"] = df["name"].apply(clean_region_name)
        df["area1_from_name"] = df["name_clean"].map(REGION_NAME_TO_CODE)
    else:
        df["name"] = np.nan
        df["area1_from_name"] = np.nan

    df["area1_num"] = to_num(df["area1"])
    df["year"] = to_num(df["year"])

    # employ3처럼 area1이 비어 있으면 name에서 지역코드 복원
    df["area1_final"] = df["area1_num"].fillna(df["area1_from_name"])

    missing_area = df[df["area1_final"].isna()][["name", "area1", "year"]].copy()
    if len(missing_area) > 0:
        print("\n[경고] 지역코드를 복원하지 못한 행:", sheet_name_for_log)
        print(missing_area.head(20))

    df = df.dropna(subset=["area1_final", "year"]).copy()
    df["area1"] = df["area1_final"].astype(int)
    df["year"] = df["year"].astype(int)

    df = df[
        (df["year"] >= DATA_START_YEAR)
        & (df["year"] <= DATA_END_YEAR)
    ].copy()

    df["sido_code"] = df["area1"].apply(normalize_sido).astype(int)
    df = df[df["sido_code"].isin(SIDO_ORDER)].copy()

    df = df.drop(
        columns=[
            "name_clean",
            "area1_from_name",
            "area1_num",
            "area1_final",
        ],
        errors="ignore",
    )

    print(
        f"[{sheet_name_for_log}] rows after prep: {len(df)}, "
        f"years: {sorted(df['year'].unique()) if len(df) > 0 else []}, "
        f"sido: {sorted(df['sido_code'].unique()) if len(df) > 0 else []}"
    )

    return df


# ============================================================
# 2. 원자료 읽기
# ============================================================

wage_raw = pd.read_excel(INPUT_FILE, sheet_name=WAGE_SHEET)
employ_wage_raw = pd.read_excel(INPUT_FILE, sheet_name=EMPLOY_WAGE_WEIGHT_SHEET)
employ_bartik_raw = pd.read_excel(INPUT_FILE, sheet_name=EMPLOY_BARTIK_SHEET)

wage = prep_base_df(wage_raw, WAGE_SHEET)
employ_wage = prep_base_df(employ_wage_raw, EMPLOY_WAGE_WEIGHT_SHEET)
employ_bartik = prep_base_df(employ_bartik_raw, EMPLOY_BARTIK_SHEET)

base_cols_original = ["name", "area1", "year"]
base_cols = ["name", "area1", "year", "sido_code"]

# 연령대(ac): wage/employ 시트에만 존재. employ3(도구용)에는 없음.
# wage/employ용 id_vars에는 ac 포함, employ3용에는 미포함.
base_cols_age = ["name", "area1", "year", "sido_code", "ac"]

raw_job_cols = [
    c for c in wage.columns
    if c not in base_cols_original + ["sido_code", "ac"]
]

drop_jobs_lower = {str(j).lower() for j in DROP_JOBS}

job_cols = [
    c for c in raw_job_cols
    if str(c).lower() not in drop_jobs_lower
]

missing_in_employ_wage = [c for c in job_cols if c not in employ_wage.columns]
missing_in_employ_bartik = [c for c in job_cols if c not in employ_bartik.columns]

if missing_in_employ_wage:
    raise ValueError(
        f"{EMPLOY_WAGE_WEIGHT_SHEET} 시트에 없는 산업 컬럼: {missing_in_employ_wage}"
    )

if missing_in_employ_bartik:
    raise ValueError(
        f"{EMPLOY_BARTIK_SHEET} 시트에 없는 산업 컬럼: {missing_in_employ_bartik}"
    )

print("\n사용 산업 컬럼:", job_cols)
print("산업 수:", len(job_cols))


# ============================================================
# 3. 시도권 x 산업 x 연도 level wage 패널 생성
# ============================================================

wage_long = wage.melt(
    id_vars=base_cols_age,
    value_vars=job_cols,
    var_name="job",
    value_name="wage",
)

employ_wage_long = employ_wage.melt(
    id_vars=base_cols_age,
    value_vars=job_cols,
    var_name="job",
    value_name="employ_wage_weight",
)

wage_df = wage_long.merge(
    employ_wage_long,
    on=["name", "area1", "year", "sido_code", "ac", "job"],
    how="outer",
)

wage_df["wage"] = to_num(wage_df["wage"])
wage_df["employ_wage_weight"] = to_num(
    wage_df["employ_wage_weight"]
).fillna(0)

wage_df["valid_wage"] = (
    wage_df["wage"].notna()
    & (wage_df["wage"] > MIN_VALID_WAGE)
    & wage_df["employ_wage_weight"].notna()
    & (wage_df["employ_wage_weight"] > MIN_VALID_WEIGHT)
)

wage_df["wage_num"] = np.where(
    wage_df["valid_wage"],
    wage_df["wage"] * wage_df["employ_wage_weight"],
    0.0,
)

wage_df["wage_den"] = np.where(
    wage_df["valid_wage"],
    wage_df["employ_wage_weight"],
    0.0,
)

wage_panel = (
    wage_df
    .groupby(["sido_code", "ac", "job", "year"], as_index=False)
    .agg(
        wage_num=("wage_num", "sum"),
        wage_den=("wage_den", "sum"),
    )
)

wage_panel["wage"] = wage_panel["wage_num"] / wage_panel["wage_den"]
wage_panel.loc[wage_panel["wage_den"] <= 0, "wage"] = np.nan

wage_panel = add_sido_labels(wage_panel)


# ============================================================
# 4. 시도권 x 산업 x 연도 employ3 패널 생성
# ============================================================

employ_bartik_long = employ_bartik.melt(
    id_vars=base_cols,
    value_vars=job_cols,
    var_name="job",
    value_name="employ_bartik",
)

employ_bartik_long["employ_bartik"] = to_num(
    employ_bartik_long["employ_bartik"]
).fillna(0)

employ_bartik_panel = (
    employ_bartik_long
    .groupby(["sido_code", "job", "year"], as_index=False)
    .agg(employ_bartik=("employ_bartik", "sum"))
)

employ_bartik_panel = add_sido_labels(employ_bartik_panel)


# ============================================================
# 5. 완전한 16 x 17 x 9 패널 틀 생성
# ============================================================

# 연령대 목록 (wage 패널용)
AC_LIST = sorted(wage_panel["ac"].dropna().unique().tolist())

# wage 패널용 완전 틀: 시도 x 산업 x 연령대 x 연도
full_index_age = pd.MultiIndex.from_product(
    [
        SIDO_ORDER,
        job_cols,
        AC_LIST,
        range(DATA_START_YEAR, DATA_END_YEAR + 1),
    ],
    names=["sido_code", "job", "ac", "year"],
).to_frame(index=False)

full_index_age = add_sido_labels(full_index_age)

# employ3(도구)용 완전 틀: 시도 x 산업 x 연도 (연령 무관)
full_index = pd.MultiIndex.from_product(
    [
        SIDO_ORDER,
        job_cols,
        range(DATA_START_YEAR, DATA_END_YEAR + 1),
    ],
    names=["sido_code", "job", "year"],
).to_frame(index=False)

full_index = add_sido_labels(full_index)

wage_panel = full_index_age.merge(
    wage_panel[
        [
            "sido_code",
            "ac",
            "job",
            "year",
            "wage_num",
            "wage_den",
            "wage",
        ]
    ],
    on=["sido_code", "ac", "job", "year"],
    how="left",
)

employ_bartik_panel = full_index.merge(
    employ_bartik_panel[
        [
            "sido_code",
            "job",
            "year",
            "employ_bartik",
        ]
    ],
    on=["sido_code", "job", "year"],
    how="left",
)

employ_bartik_panel["employ_bartik"] = (
    employ_bartik_panel["employ_bartik"].fillna(0)
)


# ============================================================
# 6. same-industry other-region Bartik IV 생성
#
# Z_{r,s,t}
# = exposure_{r,s,2011} * g_{-r,s,t}
#
# exposure_{r,s,2011}
# = E_{r,s,2011} / sum_q E_{r,q,2011}
#
# g_{-r,s,t}
# = log(E_{-r,s,t}) - log(E_{-r,s,2011})   if USE_LOG_EMP_GROWTH=True
# ============================================================

emp = employ_bartik_panel.copy()
emp["employ_bartik"] = to_num(emp["employ_bartik"]).fillna(0)

# 기준연도 지역 x 산업 고용
emp_base_cell = emp[emp["year"] == BASE_YEAR][
    [
        "sido_code",
        "job",
        "employ_bartik",
    ]
].copy()

emp_base_cell = emp_base_cell.rename(
    columns={"employ_bartik": "emp_rs_base"}
)

# 기준연도 지역 총고용
emp_base_region_total = (
    emp_base_cell
    .groupby("sido_code", as_index=False)
    .agg(emp_r_base_total=("emp_rs_base", "sum"))
)

emp_base_cell = emp_base_cell.merge(
    emp_base_region_total,
    on="sido_code",
    how="left",
)

emp_base_cell["exposure_rs_base"] = np.where(
    emp_base_cell["emp_r_base_total"] > 0,
    emp_base_cell["emp_rs_base"] / emp_base_cell["emp_r_base_total"],
    np.nan,
)

# 현재연도 지역 x 산업 고용
emp_current = emp[
    (emp["year"] >= MODEL_START_YEAR)
    & (emp["year"] <= MODEL_END_YEAR)
][
    [
        "sido_code",
        "job",
        "year",
        "employ_bartik",
    ]
].copy()

emp_current = emp_current.rename(
    columns={"employ_bartik": "emp_rst"}
)

# 산업 x 연도 전체 고용
emp_industry_year_total = (
    emp_current
    .groupby(["job", "year"], as_index=False)
    .agg(emp_st_all=("emp_rst", "sum"))
)

# 산업 기준연도 전체 고용
emp_industry_base_total = (
    emp_base_cell
    .groupby("job", as_index=False)
    .agg(emp_s_base_all=("emp_rs_base", "sum"))
)

bartik = emp_current.merge(
    emp_base_cell[
        [
            "sido_code",
            "job",
            "emp_rs_base",
            "exposure_rs_base",
        ]
    ],
    on=["sido_code", "job"],
    how="left",
)

bartik = bartik.merge(
    emp_industry_year_total,
    on=["job", "year"],
    how="left",
)

bartik = bartik.merge(
    emp_industry_base_total,
    on="job",
    how="left",
)

bartik["emp_minus_r_s_t"] = (
    bartik["emp_st_all"] - bartik["emp_rst"]
)

bartik["emp_minus_r_s_base"] = (
    bartik["emp_s_base_all"] - bartik["emp_rs_base"]
)

if USE_LOG_EMP_GROWTH:
    bartik["external_growth_same_industry_loo"] = np.where(
        (bartik["emp_minus_r_s_t"] > 0)
        & (bartik["emp_minus_r_s_base"] > 0),
        np.log(bartik["emp_minus_r_s_t"])
        - np.log(bartik["emp_minus_r_s_base"]),
        np.nan,
    )
else:
    bartik["external_growth_same_industry_loo"] = np.where(
        bartik["emp_minus_r_s_base"] > 0,
        (
            bartik["emp_minus_r_s_t"]
            - bartik["emp_minus_r_s_base"]
        )
        / bartik["emp_minus_r_s_base"],
        np.nan,
    )

bartik["iv_bartik_emp"] = (
    bartik["exposure_rs_base"]
    * bartik["external_growth_same_industry_loo"]
)

bartik_iv = bartik[
    [
        "sido_code",
        "job",
        "year",
        "iv_bartik_emp",
        "exposure_rs_base",
        "external_growth_same_industry_loo",
        "emp_minus_r_s_t",
        "emp_minus_r_s_base",
    ]
].copy()


# ============================================================
# 7. 2011년 셀 임금 및 수렴통제 생성
#
# ln_wage_base = ln(wage_{r,s,2011})
#
# 수렴통제:
# conv_2013 = ln_wage_base * 1[year=2013]
# ...
# conv_2019 = ln_wage_base * 1[year=2019]
#
# 2012는 omitted base year.
# ============================================================

base_wage = wage_panel[wage_panel["year"] == BASE_YEAR][
    [
        "sido_code",
        "ac",
        "job",
        "wage",
    ]
].copy()

base_wage = base_wage.rename(
    columns={"wage": "wage_base_2011"}
)

base_wage["ln_wage_base_2011"] = np.where(
    base_wage["wage_base_2011"] > 0,
    np.log(base_wage["wage_base_2011"]),
    np.nan,
)


# ============================================================
# 8. first-stage 데이터 구성
# ============================================================

# 도구는 시도 x 산업 x 연도 수준(연령 무관) → wage_panel(ac 포함)에 병합되며
# 4개 연령대 셀에 동일 값으로 복제됨
first_stage = wage_panel.merge(
    bartik_iv,
    on=["sido_code", "job", "year"],
    how="left",
)

# 수렴통제용 기준임금은 연령대별로 병합
first_stage = first_stage.merge(
    base_wage[
        [
            "sido_code",
            "ac",
            "job",
            "wage_base_2011",
            "ln_wage_base_2011",
        ]
    ],
    on=["sido_code", "ac", "job"],
    how="left",
)

first_stage = first_stage[
    (first_stage["year"] >= MODEL_START_YEAR)
    & (first_stage["year"] <= MODEL_END_YEAR)
].copy()

first_stage = first_stage.sort_values(
    [
        "sido_code",
        "ac",
        "job",
        "year",
    ]
).copy()

# 개체(unit) = 시도 x 산업 x 연령대
first_stage["unit"] = (
    first_stage["sido_code"].astype(str)
    + "_"
    + first_stage["job"].astype(str)
    + "_ac"
    + first_stage["ac"].astype(int).astype(str)
)

first_stage["year"] = first_stage["year"].astype(int)


# ============================================================
# 9. 산업 x 연도 FE 및 수렴통제 변수 생성
#
# region-industry FE는 PanelOLS entity_effects=True로 통제.
# industry x year FE는 더미로 통제.
# year FE는 industry x year FE에 포함되므로 별도 time_effects=False.
#
# industry x year FE:
#   각 산업별 2012년을 omitted base로 두고 2013-2019 더미 생성
#
# 수렴통제:
#   ln(2011 cell wage) x year dummy
#   2012년 omitted base, 2013-2019 생성
# ============================================================

job_year_cols = []
age_year_cols = []
conv_cols = []

# industry x year FE (2008 omitted base year)
for j in job_cols:
    for yr in range(MODEL_START_YEAR + 1, MODEL_END_YEAR + 1):
        col = f"jy_{j}_{yr}"
        first_stage[col] = (
            (first_stage["job"].astype(str) == str(j))
            & (first_stage["year"] == yr)
        ).astype(float)
        job_year_cols.append(col)

# age-group x year FE (2008 omitted base year)
#   연령대별 연도충격(최저임금 등 연령대별로 다르게 작용하는 충격) 통제
for a in AC_LIST[1:]:  # 첫 연령대는 omitted base (완전공선 방지)
    for yr in range(MODEL_START_YEAR + 1, MODEL_END_YEAR + 1):
        col = f"ay_ac{int(a)}_{yr}"
        first_stage[col] = (
            (first_stage["ac"] == a)
            & (first_stage["year"] == yr)
        ).astype(float)
        age_year_cols.append(col)

# 수렴통제: (2008 cell wage, LEVEL) x year (2008 omitted base year)
#   종속변수가 level wage이므로 baseline도 level로 두어 스케일을 일치시킴.
for yr in range(MODEL_START_YEAR + 1, MODEL_END_YEAR + 1):
    col = f"conv_wage2011_{yr}"
    first_stage[col] = np.where(
        first_stage["year"] == yr,
        first_stage["wage_base_2011"],
        0.0,
    )
    conv_cols.append(col)


# ============================================================
# 10. first-stage 모델 데이터
# ============================================================

exog_vars = ["iv_bartik_emp"] + job_year_cols + age_year_cols + conv_cols

model_cols = [
    DEP_VAR,
    "iv_bartik_emp",
    "unit",
    "year",
    "sido_code",
    "ac",
    "job",
    "wage_base_2011",
] + job_year_cols + age_year_cols + conv_cols

first_stage_model = first_stage.dropna(
    subset=model_cols
).copy()

first_stage_model = first_stage_model.sort_values(
    [
        "unit",
        "year",
    ]
).copy()


# ============================================================
# 11. IV 진단
# ============================================================

print("\n" + "=" * 80)
print("FIRST-STAGE INPUT DIAGNOSTICS")
print("=" * 80)
print(f"Raw first-stage rows: {len(first_stage)}")
print(f"Model rows after dropna: {len(first_stage_model)}")
print(f"Number of units: {first_stage_model['unit'].nunique()}")
print(f"Number of years: {first_stage_model['year'].nunique()}")
print(f"Number of job-year FE dummies: {len(job_year_cols)}")
print(f"Number of age-year FE dummies: {len(age_year_cols)}")
print(f"Number of convergence controls: {len(conv_cols)}")
print()
print("wage missing:", first_stage[DEP_VAR].isna().sum())
print("iv_bartik_emp missing:", first_stage["iv_bartik_emp"].isna().sum())
print("wage_base_2011 missing:", first_stage["wage_base_2011"].isna().sum())
print()
print("iv_bartik_emp summary:")
print(first_stage_model["iv_bartik_emp"].describe())
print()
print("iv_bartik_emp unique values:")
print(first_stage_model["iv_bartik_emp"].nunique(dropna=True))

if len(first_stage_model) == 0:
    raise ValueError(
        "first_stage_model is empty. Check wage, iv_bartik_emp, or baseline wage missing values."
    )

if first_stage_model["iv_bartik_emp"].nunique(dropna=True) <= 1:
    raise ValueError(
        "iv_bartik_emp has one or fewer unique values. Check employ3 and BASE_YEAR settings."
    )

tmp = first_stage_model[["unit", "year", "iv_bartik_emp"]].copy()
tmp["x"] = tmp["iv_bartik_emp"]

entity_mean = tmp.groupby("unit")["x"].transform("mean")
time_mean = tmp.groupby("year")["x"].transform("mean")
grand_mean = tmp["x"].mean()

tmp["x_tw_demeaned"] = tmp["x"] - entity_mean - time_mean + grand_mean
tw_std = tmp["x_tw_demeaned"].std()

print()
print(f"Two-way demeaned std of iv_bartik_emp, before added controls: {tw_std}")


# ============================================================
# 12. first stage 추정
#
# wage_{r,s,t}
# = pi * iv_bartik_emp_{r,s,t}
# + region-industry FE
# + industry-year FE
# + ln(wage_{r,s,2011}) x year controls
# + residual_{r,s,t}
# ============================================================

if HAS_LINEARMODELS:
    fs_idx = first_stage_model.set_index(["unit", "year"])

    y = fs_idx[DEP_VAR]
    X = fs_idx[exog_vars].astype(float)

    model = PanelOLS(
        dependent=y,
        exog=X,
        entity_effects=True,
        time_effects=False,

    )

    if CLUSTER_LEVEL == "region":
        clusters = fs_idx[["sido_code"]]
        result = model.fit(
            cov_type="clustered",
            clusters=clusters,
        )
        cluster_desc = "region clustered"
    else:
        result = model.fit(
            cov_type="clustered",
            cluster_entity=True,
        )
        cluster_desc = "unit clustered"

    print("\n" + "=" * 80)
    print("FIRST-STAGE RESULT")
    print("=" * 80)
    print(result)

    fs_idx["resid"] = result.resids
    fs_idx["wage_hat"] = fs_idx[DEP_VAR] - fs_idx["resid"]

    out = fs_idx.reset_index()
    engine_used = "linearmodels.PanelOLS"

else:
    rhs = " + ".join(exog_vars)
    formula = f"{DEP_VAR} ~ {rhs} + C(unit) - 1"

    if CLUSTER_LEVEL == "region":
        cluster_groups = first_stage_model["sido_code"]
        cluster_desc = "region clustered"
    else:
        cluster_groups = first_stage_model["unit"]
        cluster_desc = "unit clustered"

    result = smf.ols(
        formula,
        data=first_stage_model,
    ).fit(
        cov_type="cluster",
        cov_kwds={"groups": cluster_groups},
    )

    print("\n" + "=" * 80)
    print("FIRST-STAGE RESULT")
    print("=" * 80)
    print(result.summary())

    out = first_stage_model.copy()
    out["resid"] = result.resid
    out["wage_hat"] = result.fittedvalues

    engine_used = "statsmodels OLS with unit FE dummies"


first_stage_out = first_stage.merge(
    out[
        [
            "unit",
            "year",
            "resid",
            "wage_hat",
        ]
    ],
    on=["unit", "year"],
    how="left",
)


# ============================================================
# 13. 출력용 wide panel 생성
# ============================================================

def make_panel_wide(df, value_col):
    wide = (
        df
        .pivot_table(
            index=[
                "year",
                "sido_code",
                "ac",
                "name2",
                "sido",
                "sido_kr",
            ],
            columns="job",
            values=value_col,
            aggfunc="first",
        )
        .reset_index()
    )

    ordered_cols = (
        [
            "year",
            "sido_code",
            "ac",
            "name2",
            "sido",
            "sido_kr",
        ]
        + [j for j in job_cols if j in wide.columns]
    )

    wide = wide[ordered_cols]

    wide["sido_order"] = wide["sido_code"].map(
        {code: i for i, code in enumerate(SIDO_ORDER)}
    )

    wide = (
        wide
        .sort_values(["year", "sido_order", "ac"])
        .drop(columns="sido_order")
        .reset_index(drop=True)
    )

    return wide


actual_lnwage_panel = make_panel_wide(
    df=first_stage_out,
    value_col="wage",
)

resid_lnwage_panel = make_panel_wide(
    df=first_stage_out,
    value_col="resid",
)


# ============================================================
# 14. 저장
#
# 엑셀 시트는 두 개만 저장:
# 1. actual_lnwage_panel
# 2. resid_lnwage_panel
# ============================================================

with pd.ExcelWriter(OUTPUT_FILE, engine="openpyxl") as writer:
    actual_lnwage_panel.to_excel(
        writer,
        sheet_name="actual_lnwage_panel",
        index=False,
    )

    resid_lnwage_panel.to_excel(
        writer,
        sheet_name="resid_lnwage_panel",
        index=False,
    )


# ============================================================
# 15. 로그 출력
# ============================================================

print("\n" + "=" * 80)
print(f"저장 완료: {OUTPUT_FILE}")
print("=" * 80)
print("저장된 시트:")
print("1. actual_lnwage_panel : 선택모형 투입용 level wage")
print("2. resid_lnwage_panel  : extended Bartik first-stage residual")
print()
print(
    f"분석 단위: {len(SIDO_ORDER)}개 시도권 "
    f"x {len(job_cols)}개 산업 "
    f"x {MODEL_END_YEAR - MODEL_START_YEAR + 1}개 추정연도"
)
print(f"자료기간: {DATA_START_YEAR}-{DATA_END_YEAR}")
print(f"기준연도: {BASE_YEAR}")
print(f"추정기간: {MODEL_START_YEAR}-{MODEL_END_YEAR}")
print("세종(29)은 충남(34)에 병합")
print("제주(39)는 유지")
print(f"DROP_JOBS: {DROP_JOBS}")
print(f"DEP_VAR: {DEP_VAR}")
print("IV: iv_bartik_emp")
print("    = 2011년 지역 r의 산업 s 고용노출도 x 같은 산업 s의 타지역 LOO 종사자수 성장률")
print("Additional controls:")
print("    1. industry x year FE")
print("    2. ln(2011 region-industry wage) x year controls")
print("Omitted year for added controls: 2012")
print(f"USE_LOG_EMP_GROWTH: {USE_LOG_EMP_GROWTH}")
print(f"Cluster: {cluster_desc}")
print(f"추정 엔진: {engine_used}")
print()
print("주의:")
print("actual_lnwage_panel이라는 시트명은 기존 SAS 호환을 위해 유지했지만, 실제 값은 level wage임.")
print("resid_lnwage_panel이라는 시트명도 기존 SAS 호환을 위해 유지했지만, 실제 값은 level-wage residual임.")