/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile "&KEUS\2012.csv"
        delimiter = ','
        MISSOVER
        DSD
        lrecl=32767
        firstobs = 2;

    informat C1 $6. ;
    informat C2 $2. ;
    informat C3 $1. ;
    informat C4 $1. ;
    informat C5 best12. ;
    informat C6 $1. ;
    informat C7 $1. ;
    informat C8 $1. ;
    informat C9 $1. ;
    informat C10 $1. ;
    informat C11 $2. ;
    informat C12 $1. ;
    informat C13 $2. ;
    informat C14 $1. ;
    informat C15 $1. ;
    informat C16 $1. ;
    informat C17 best12. ;
    informat C18 best12. ;
    informat C19 best12. ;
    informat C20 $1. ;
    informat C21 $2. ;
    informat C22 $2. ;
    informat C23 $2. ;
    informat C24 $2. ;
    informat C25 best12. ;
    informat C26 $1. ;
    informat C27 $2. ;
    informat C28 $1. ;
    informat C29 $1. ;
    informat C30 $6. ;
    informat C31 $1. ;
    informat C32 $4. ;
    informat C33 $2. ;
    informat C34 $1. ;
    informat C35 $1. ;
    informat C36 $1. ;
    informat C37 $1. ;
    informat C38 $1. ;
    informat C39 $6. ;
    informat C40 best12. ;
    informat C41 $1. ;
    informat C42 $1. ;
    informat C43 $2. ;
    informat C44 $2. ;
    informat C45 $2. ;
    informat C46 $1. ;
    informat C47 best12. ;
    informat C48 $2. ;
    informat C49 $1. ;
    informat C50 best12. ;
    informat C51 $1. ;
    informat C52 best12. ;
    informat C53 $6. ;

    format C1 $6. ;
    format C2 $2. ;
    format C3 $1. ;
    format C4 $1. ;
    format C5 best12. ;
    format C6 $1. ;
    format C7 $1. ;
    format C8 $1. ;
    format C9 $1. ;
    format C10 $1. ;
    format C11 $2. ;
    format C12 $1. ;
    format C13 $2. ;
    format C14 $1. ;
    format C15 $1. ;
    format C16 $1. ;
    format C17 best12. ;
    format C18 best12. ;
    format C19 best12. ;
    format C20 $1. ;
    format C21 $2. ;
    format C22 $2. ;
    format C23 $2. ;
    format C24 $2. ;
    format C25 best12. ;
    format C26 $1. ;
    format C27 $2. ;
    format C28 $1. ;
    format C29 $1. ;
    format C30 $6. ;
    format C31 $1. ;
    format C32 $4. ;
    format C33 $2. ;
    format C34 $1. ;
    format C35 $1. ;
    format C36 $1. ;
    format C37 $1. ;
    format C38 $1. ;
    format C39 $6. ;
    format C40 best12. ;
    format C41 $1. ;
    format C42 $1. ;
    format C43 $2. ;
    format C44 $2. ;
    format C45 $2. ;
    format C46 $1. ;
    format C47 best12. ;
    format C48 $2. ;
    format C49 $1. ;
    format C50 best12. ;
    format C51 $1. ;
    format C52 best12. ;
    format C53 $6. ;

    input
        C1 $
        C2 $
        C3 $
        C4 $
        C5
        C6 $
        C7 $
        C8 $
        C9 $
        C10 $
        C11 $
        C12 $
        C13 $
        C14 $
        C15 $
        C16 $
        C17
        C18
        C19
        C20 $
        C21 $
        C22 $
        C23 $
        C24 $
        C25
        C26 $
        C27 $
        C28 $
        C29 $
        C30 $
        C31 $
        C32 $
        C33 $
        C34 $
        C35 $
        C36 $
        C37 $
        C38 $
        C39 $
        C40
        C41 $
        C42 $
        C43 $
        C44 $
        C45 $
        C46 $
        C47
        C48 $
        C49 $
        C50
        C51 $
        C52
        C53 $
    ;

    label
        C1 = '조사년^분기'
        C2 = '행정구역'
        C3 = '2.가구주와의 관계'
        C4 = '3.성별'
        C5 = '4.연령(만나이)'
        C6 = '5-1.교육정도(학력)'
        C7 = '5-2.계열(고등학교인 경우)'
        C8 = '5-3.계열(전문대 이상인 경우)'
        C9 = '5-4.교육정도(수학여부)'
        C10 = '6.혼인상태'
        C11 = '7.지난1주간활동상태'
        C12 = '8.지난1주간취업여부'
        C13 = '9.일시휴직여부'
        C14 = '10.4주내 구직활동 여부'
        C15 = '11.부업여부'
        C16 = '12.취업구분'
        C17 = '12-1.주업시간'
        C18 = '12-2.부업시간'
        C19 = '12-3.총취업시간'
        C20 = '13.즉시취업 가능여부(실업)'
        C21 = '14-1.구직 주요경로1'
        C22 = '14-1.구직 주요경로2'
        C23 = '14-2.구직방법1'
        C24 = '14-2.구직방법2'
        C25 = '15.구직활동기간'
        C26 = '16.구직희망여부'
        C27 = '17.직장구하지않은이유'
        C28 = '18.지난 1년간 구직활동여부'
        C29 = '19.전직유무'
        C30 = '19-1.이직시기'
        C31 = '19.2.1년이상 구분'
        C32 = '19.2.1.만54세 이하'
        C33 = '20.직장을그만둔이유'
        C34 = '20.1.개인·가족적 이유'
        C35 = '21.그만 둔 직장에서 일한 기간'
        C36 = '22.산업코드'
        C37 = '23.직업코드'
        C38 = '24.종사상지위'
        C39 = '25.직장시작년월'
        C40 = '26.3개월 평균임금'
        C41 = '27.근로기간 계약여부'
        C42 = '27-1.근로기간'
        C43 = '28.1.국민연금 가입여부'
        C44 = '28.2.건강보험 가입여부'
        C45 = '28.3.고용보험 가입여부'
        C46 = '30.배우자가 수입 목적으로 일한 적 있었는지 여부'
        C47 = '30.1.배우자 총 일한 시간'
        C48 = '사업체소재지코드'
        C49 = '교육정도컨버전'
        C50 = '시도 및 전국 가중치'
        C51 = '경제활동상태'
        C52 = '가구가중치'
        C53 = '동일 가구 정보키'
    ;

run;


data job12;
set mdis;

year = 2012;

age = c5;
if age ge 20 and age le 39;

if input(vvalue(c51), best.) = 1; * 취업자;

wage = c40;
if wage = . then delete;

area1 = input(vvalue(c48), best.);

/* ------------------------------------------------------------
   2012년은 c36이 이미 산업대분류 코드임
   - c36: 산업코드, A~U
   - job: 산업대분류 코드 A~S만 사용
   - T, U는 제외
------------------------------------------------------------ */

length job $1;

job = upcase(strip(c36));

if job not in (
    "A", "B", "C", "D", "E", "F", "G", "H", "I",
    "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S"
) then delete;

wt = c50; * 시도 및 전국 가중치;

if      age ge 20 and age le 24 then ac=1;
else if age ge 25 and age le 29 then ac=2;
else if age ge 30 and age le 34 then ac=3;
else if age ge 35 and age le 39 then ac=4;

keep year age area1 wage job wt ac;
run;

/* ------------------------------------------------------------
   area1 × year × job별 평균임금 및 종사자수 산출 후 wide format 생성
   - wage_wide12  : area1-year별 job 평균임금
   - employ_wide12: area1-year별 job 가중 종사자수
------------------------------------------------------------ */

data job12_ready;
    set job12;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job12_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats12(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats12;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats12 out=wage_wide12(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats12 out=employ_wide12(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide12;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide12;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide12;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide12;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
