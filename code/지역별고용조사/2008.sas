/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile "&KEUS\2008.csv"
        delimiter = ','
        MISSOVER
        DSD
        lrecl=32767
        firstobs = 2;

    informat C1  $4. ;
    informat C2  $1. ;
    informat C3  $1. ;
    informat C4  best12. ;
    informat C5  $1. ;
    informat C6  $1. ;
    informat C7  $1. ;
    informat C8  $1. ;
    informat C9  $2. ;
    informat C10 $1. ;
    informat C11 $2. ;
    informat C12 $1. ;
    informat C13 $1. ;
    informat C14 $1. ;
    informat C15 $3. ;
    informat C16 $3. ;
    informat C17 $3. ;
    informat C18 $1. ;
    informat C19 $2. ;
    informat C20 $2. ;
    informat C21 $2. ;
    informat C22 $2. ;
    informat C23 $2. ;
    informat C24 $1. ;
    informat C25 $1. ;
    informat C26 $1. ;
    informat C27 $2. ;
    informat C28 $1. ;
    informat C29 $1. ;
    informat C30 $1. ;
    informat C31 $2. ;
    informat C32 $1. ;
    informat C33 $2. ;
    informat C34 $1. ;
    informat C35 $1. ;
    informat C36 $6. ;
    informat C37 $2. ;
    informat C38 $2. ;
    informat C39 $2. ;
    informat C40 $1. ;
    informat C41 $6. ;
    informat C42 best12. ;
    informat C43 $1. ;
    informat C44 $1. ;
    informat C45 $1. ;
    informat C46 $4. ;
    informat C47 best12. ;
    informat C48 $1. ;

    format C1  $4. ;
    format C2  $1. ;
    format C3  $1. ;
    format C4  best12. ;
    format C5  $1. ;
    format C6  $1. ;
    format C7  $1. ;
    format C8  $1. ;
    format C9  $2. ;
    format C10 $1. ;
    format C11 $2. ;
    format C12 $1. ;
    format C13 $1. ;
    format C14 $1. ;
    format C15 $3. ;
    format C16 $3. ;
    format C17 $3. ;
    format C18 $1. ;
    format C19 $2. ;
    format C20 $2. ;
    format C21 $2. ;
    format C22 $2. ;
    format C23 $2. ;
    format C24 $1. ;
    format C25 $1. ;
    format C26 $1. ;
    format C27 $2. ;
    format C28 $1. ;
    format C29 $1. ;
    format C30 $1. ;
    format C31 $2. ;
    format C32 $1. ;
    format C33 $2. ;
    format C34 $1. ;
    format C35 $1. ;
    format C36 $6. ;
    format C37 $2. ;
    format C38 $2. ;
    format C39 $2. ;
    format C40 $1. ;
    format C41 $6. ;
    format C42 best12. ;
    format C43 $1. ;
    format C44 $1. ;
    format C45 $1. ;
    format C46 $4. ;
    format C47 best12. ;
    format C48 $1. ;

    input
        C1  $
        C2  $
        C3  $
        C4
        C5  $
        C6  $
        C7  $
        C8  $
        C9  $
        C10 $
        C11 $
        C12 $
        C13 $
        C14 $
        C15 $
        C16 $
        C17 $
        C18 $
        C19 $
        C20 $
        C21 $
        C22 $
        C23 $
        C24 $
        C25 $
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
        C40 $
        C41 $
        C42
        C43 $
        C44 $
        C45 $
        C46 $
        C47
        C48 $
    ;

    label
        C1  = '행정구역'
        C2  = '가구주와의 관계'
        C3  = '성별'
        C4  = '연령(만나이)'
        C5  = '교육정도(학력)'
        C6  = '계열'
        C7  = '교육정도(수학여부)'
        C8  = '혼인상태'
        C9  = '7.지난1주간활동상태'
        C10 = '8.지난1주간취업여부'
        C11 = '9.일시휴직여부'
        C12 = '10.1개월간 구직여부'
        C13 = '11.부업여부'
        C14 = '12.취업구분'
        C15 = '12-1.주업시간'
        C16 = '12-2.부업시간'
        C17 = '12-3.총취업시간'
        C18 = '취업가능성(실업)'
        C19 = '14_1_1.구직 주요경로'
        C20 = '14_1_2.구직 주요경로'
        C21 = '14_2_1.구직방법'
        C22 = '14_2_2.구직방법'
        C23 = '15.구직활동기간'
        C24 = '16.구직분야'
        C25 = '17.구직종류'
        C26 = '18.희망직장지위'
        C27 = '18_1.근로종류'
        C28 = '19.희망월평균소득'
        C29 = '20.구직의사유무'
        C30 = '20_1.희망종사지위'
        C31 = '20_1_1.근로종류'
        C32 = '20_2.희망월평균소득'
        C33 = '21.직장구하지않는이유'
        C34 = '22.구직활동유무'
        C35 = '23.전직유무'
        C36 = '23_이직시기'
        C37 = '24.직장을그만둔이유'
        C38 = '25_산업코드'
        C39 = '26_직업코드'
        C40 = '27.종사상지위'
        C41 = '28_직업시작년월'
        C42 = '29_월평균임금'
        C43 = '30.고용계약여부'
        C44 = '30-1.고용계약기간'
        C45 = '31.직업교육(훈련)여부'
        C46 = '사업체소재지'
        C47 = '시군 가중치'
        C48 = '경제활동구분'
    ;

run;


data job08;
set mdis;

year = 2008;
age = c4;
if age ge 20 and age le 39;

if      age ge 20 and age le 24 then ac=1;
else if age ge 25 and age le 29 then ac=2;
else if age ge 30 and age le 34 then ac=3;
else if age ge 35 and age le 39 then ac=4;

if input(vvalue(c48), best.) = 1; * 취업자;

wage = c42;
if wage = . then delete;

area1_raw = input(vvalue(c46), best.);
area1 = floor(area1_raw / 100);
if area1_raw in (8888, 9998, 9999) then delete;
if area1 = . then delete;

/* ── 산업 재분류 (원본과 동일) ── */
length job $1;
c38n = input(vvalue(c38), best.);
if c38n in (1,2,3) then job="A";
else if c38n in (5,6,7,8) then job="B";
else if c38n in (10,11,12,13,14,15,16,17,18,19,
                 20,21,22,23,24,25,26,27,28,29,
                 30,31,32,33) then job="C";
else if c38n in (35,36) then job="D";
else if c38n in (37,38,39) then job="E";
else if c38n in (41,42) then job="F";
else if c38n in (45,46,47) then job="G";
else if c38n in (49,50,51,52) then job="H";
else if c38n in (55,56) then job="I";
else if c38n in (58,59,60,61,62,63) then job="J";
else if c38n in (64,65,66) then job="K";
else if c38n in (68,69) then job="L";
else if c38n in (70,71,72,73) then job="M";
else if c38n in (74,75) then job="N";
else if c38n in (84) then job="O";
else if c38n in (85) then job="P";
else if c38n in (86,87) then job="Q";
else if c38n in (90,91) then job="R";
else if c38n in (94,95,96) then job="S";
else job=".";
if job="." then delete;

wt = c47;

keep year age ac area1 wage job wt ac1 ac2 ac3 ac4;
run;


/* ============================================================
   area1 × year × 연령대(ac) × job 별 평균임금·종사자수
   → wide는 연령대별로 4개 블록이 쌓인 형태
   ============================================================ */

data job08_ready;
    set job08;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job08_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats08(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats08;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats08 out=wage_wide08(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats08 out=employ_wide08(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide08;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide08;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide08;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide08;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
