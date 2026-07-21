"""
GOMS Mixed Logit Premium Simulation (Scenarios 1-4)
- Mixed logit: wages/high/college ~ Normal(mean, sd) draw, sample enumeration
- 각 시도(서울 제외) 임금을 0~100% 올려 서울 점유율과 교차하는 지점(프리미엄) 탐색
- 2015 / 2020 각각 (y_* 연도 상호작용 반영)
- 시나리오 1(실제) / 2(high=서울) / 3(college=서울) / 4(둘다 서울)
"""
import numpy as np
import pandas as pd
from pathlib import Path
import matplotlib.pyplot as plt
import matplotlib

matplotlib.rcParams['font.family'] = 'DejaVu Sans'
matplotlib.rcParams['axes.unicode_minus'] = False

# ============================================================
# 0. 경로 & 설정
# ============================================================
BASE = Path(r"D:\이경재\학술대회 및 논문공모전\2027 Journal of Regional Science\분석")
DATA = BASE / "data" / "pooled.dta"                                              # 실제 경로 확인
COEF = BASE / "logitr_results" / "pooled_wages_high_college_draws100_starts5_coef.csv"     # 실제 경로 확인

OUT = {
    1: BASE / "시뮬레이션1",
    2: BASE / "시뮬레이션2",
    3: BASE / "시뮬레이션3",
    4: BASE / "시뮬레이션4",
}
for p in OUT.values():
    p.mkdir(parents=True, exist_ok=True)

R_DRAWS    = 200          # 개인 공통 계수 draw 수 (이질성 반영)
SEED       = 20260717
DELTA_MAX  = 1.00         # 임금 인상 상한 (100%). 역전불가 많으면 2.00으로.
DELTA_STEP = 0.005        # 교차점 탐색 격자
SEOUL      = 1

# 1..16 순서: 서울 부산 대구 인천 광주 대전 울산 경기 강원 충북 충남(세종포함) 전북 전남 경북 경남 제주
SIDO_NAME = {
    1:"Seoul", 2:"Busan", 3:"Daegu", 4:"Incheon", 5:"Gwangju",
    6:"Daejeon", 7:"Ulsan", 8:"Gyeonggi", 9:"Gangwon", 10:"Chungbuk",
    11:"Chungnam", 12:"Jeonbuk", 13:"Jeonnam", 14:"Gyeongbuk",
    15:"Gyeongnam", 16:"Jeju"
}
METRO_EXCLUDE = {"Gyeonggi", "Incheon"}   # 곡선 선택 시 수도권 제외

# ============================================================
# 1. 계수 로드
# ============================================================
coef = pd.read_csv(COEF)
coef.columns = [c.strip() for c in coef.columns]
cdict = dict(zip(coef['term'], coef['Estimate']))

MU = {'wages': cdict['wages'], 'high': cdict['high'], 'college': cdict['college']}
DY = {'wages': cdict.get('y_wages',0.0), 'high': cdict.get('y_high',0.0),
      'college': cdict.get('y_college',0.0), 'res': cdict.get('y_res',0.0)}
SD = {'wages': abs(cdict['sd_wages']), 'high': abs(cdict['sd_high']),
      'college': abs(cdict['sd_college'])}
RES_COEF = cdict['res']

# 고정 계수 = random(wages/high/college) 및 그 y_*, sd_* 제외한 나머지 전부
RANDOM_TERMS = {'wages','y_wages','res','y_res','high','y_high','college','y_college',
                'sd_wages','sd_high','sd_college'}
FIXED_TERMS = [t for t in coef['term'] if t not in RANDOM_TERMS]

print("MU:", {k:round(v,3) for k,v in MU.items()})
print("SD:", {k:round(v,3) for k,v in SD.items()})
print("DY:", {k:round(v,3) for k,v in DY.items()})
print("res:", round(RES_COEF,3), "| n fixed:", len(FIXED_TERMS))

# ============================================================
# 2. 데이터 로드
# ============================================================
df = pd.read_stata(DATA)
missing = [t for t in FIXED_TERMS if t not in df.columns]
if missing:
    raise ValueError(f"데이터에 없는 고정항: {missing[:15]}")

def prep_year(dsub, is2020):
    """개인×16 배열 구성 + 고정효용(Vfix) 미리 계산."""
    dsub = dsub.sort_values(['subject_pool','i'])
    A = 16
    n_ind = dsub['subject_pool'].nunique()
    def col(name):
        return dsub[name].values.reshape(n_ind, A).astype(float)
    pack = {
        'wages':   col('wages'),
        'high':    col('high'),
        'college': col('college'),
        'n_ind':   n_ind,
    }
    # 고정 효용 (draw 무관): 대안더미 + 상호작용 (a*_y2020은 데이터에 이미 있으므로 그대로 사용)
    Vfix = np.zeros((n_ind, A))
    for t in FIXED_TERMS:
        b = cdict[t]
        if b != 0:
            Vfix += b * col(t)
    # res 고정계수 (2020이면 +y_res)
    res_c = RES_COEF + (DY['res'] if is2020 else 0.0)
    Vfix += res_c * col('res')
    pack['Vfix'] = Vfix
    return pack

# ============================================================
# 3. 시뮬레이션 코어 (mixed logit sample enumeration)
# ============================================================
def simulate_shares(pack, is2020, delta, target_idx,
                    high_override=None, college_override=None, rng=None):
    """target_idx(0-indexed) 임금 (1+delta)배 시 전체 평균 점유율(16,)."""
    n = pack['n_ind']; A = 16
    Vfix = pack['Vfix']
    wages = pack['wages'].copy()
    high  = pack['high']    if high_override    is None else np.tile(high_override,(n,1)).astype(float)
    college = pack['college'] if college_override is None else np.tile(college_override,(n,1)).astype(float)

    wages_sim = wages.copy()
    wages_sim[:, target_idx] *= (1.0 + delta)

    mu_w = MU['wages']   + (DY['wages']   if is2020 else 0.0)
    mu_h = MU['high']    + (DY['high']    if is2020 else 0.0)
    mu_c = MU['college'] + (DY['college'] if is2020 else 0.0)

    R = R_DRAWS
    bw = mu_w + SD['wages']   * rng.standard_normal(R)
    bh = mu_h + SD['high']    * rng.standard_normal(R)
    bc = mu_c + SD['college'] * rng.standard_normal(R)

    prob_sum = np.zeros((n, A))
    for r in range(R):
        V = Vfix + bw[r]*wages_sim + bh[r]*high + bc[r]*college
        V -= V.max(axis=1, keepdims=True)
        eV = np.exp(V)
        prob_sum += eV / eV.sum(axis=1, keepdims=True)
    P_mean = prob_sum / R
    return P_mean.mean(axis=0)   # (16,)

def find_crossing(pack, is2020, target_idx, hov, cov, seed):
    """target 임금 올려 서울과 교차하는 delta. 없으면 None."""
    rng = np.random.default_rng(seed)
    seoul_idx = SEOUL - 1
    deltas = np.arange(0, DELTA_MAX + 1e-9, DELTA_STEP)
    prev_diff, prev_d = None, 0.0
    for d in deltas:
        # 교차점 탐색은 draw 고정(seed 재사용)으로 단조성 확보
        rng_d = np.random.default_rng(seed)
        sh = simulate_shares(pack, is2020, d, target_idx, hov, cov, rng_d)
        diff = sh[target_idx] - sh[seoul_idx]
        if prev_diff is not None and prev_diff < 0 <= diff:
            frac = -prev_diff / (diff - prev_diff)
            return prev_d + frac * DELTA_STEP
        prev_diff, prev_d = diff, d
    return None

# ============================================================
# 4. 시나리오 정의
# ============================================================
def seoul_vec():
    v = np.zeros(16); v[SEOUL-1] = 1.0; return v

SCENARIOS = {
    1: dict(name="actual",        high=None,        college=None),
    2: dict(name="seoul_high",    high=seoul_vec(), college=None),
    3: dict(name="seoul_college", high=None,        college=seoul_vec()),
    4: dict(name="seoul_both",    high=seoul_vec(), college=seoul_vec()),
}
YEARS = {2015: False, 2020: True}

# ============================================================
# 5. 실행
# ============================================================
for scn, cfg in SCENARIOS.items():
    outdir = OUT[scn]
    results = {}
    packs = {}

    for yr, is2020 in YEARS.items():
        dsub = df[df['y2020'] == (1 if is2020 else 0)]
        pack = prep_year(dsub, is2020)
        packs[yr] = (pack, is2020)

        prem = {}
        for j in range(2, 17):
            cross = find_crossing(pack, is2020, j-1, cfg['high'], cfg['college'], SEED+j)
            prem[SIDO_NAME[j]] = (cross*100 if cross is not None else np.nan)
        results[yr] = prem
        print(f"[Scn{scn} {cfg['name']} {yr}] {sum(np.isnan(list(prem.values())))} 역전불가 / 15")

    # ---- 엑셀 표 (2015, 2020 열) ----
    tbl = pd.DataFrame({
        'Sido': list(results[2015].keys()),
        'Premium_2015(%)': [round(v,1) if not np.isnan(v) else None for v in results[2015].values()],
        'Premium_2020(%)': [round(v,1) if not np.isnan(v) else None for v in results[2020].values()],
    }).sort_values('Premium_2020(%)', na_position='last').reset_index(drop=True)
    tbl.to_excel(outdir / f"premium_table_scn{scn}_{cfg['name']}.xlsx", index=False)

    # ---- 곡선 그림 (연도별, 최소/최대 프리미엄 지역) ----
    for yr, (pack, is2020) in packs.items():
        prem = results[yr]
        cand = {k:v for k,v in prem.items() if (not np.isnan(v)) and k not in METRO_EXCLUDE}
        if not cand:
            continue
        min_sido = min(cand, key=cand.get)
        max_sido = max(cand, key=cand.get)

        fig, axes = plt.subplots(1, 2, figsize=(14,5))
        for ax, sido in zip(axes, [min_sido, max_sido]):
            j = [k for k,v in SIDO_NAME.items() if v==sido][0]
            deltas = np.arange(0, DELTA_MAX+1e-9, 0.02)
            tsh, ssh = [], []
            for d in deltas:
                rng_d = np.random.default_rng(SEED+j)
                sh = simulate_shares(pack, is2020, d, j-1, cfg['high'], cfg['college'], rng_d)
                tsh.append(sh[j-1]*100); ssh.append(sh[SEOUL-1]*100)
            ax.plot(deltas*100, ssh, label='Seoul', lw=2)
            ax.plot(deltas*100, tsh, label=sido, lw=2)
            cx = prem[sido]
            if not np.isnan(cx):
                ax.axvline(cx, ls='--', alpha=0.6)
                ax.text(cx, max(max(tsh),max(ssh))*0.9, f"{cx:.1f}%", fontsize=11)
            ax.set_xlabel(f"{sido} wage premium (%)")
            ax.set_ylabel("Predicted choice probability (%)")
            ax.legend(); ax.set_title(f"Scn{scn} {cfg['name']} {yr}: {sido}")
        plt.tight_layout()
        fig.savefig(outdir / f"curves_scn{scn}_{cfg['name']}_{yr}.png", dpi=200)
        plt.close(fig)

    print(f"=== Scenario {scn} saved -> {outdir}\n")

print("ALL DONE")