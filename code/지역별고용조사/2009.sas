/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile "&KEUS\2009.csv"
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
    informat C25 $2. ;
    informat C26 $1. ;
    informat C27 $1. ;
    informat C28 $1. ;
    informat C29 $1. ;
    informat C30 $2. ;
    informat C31 $1. ;
    informat C32 $1. ;
    informat C33 $6. ;
    informat C34 $2. ;
    informat C35 $2. ;
    informat C36 $2. ;
    informat C37 $1. ;
    informat C38 $6. ;
    informat C39 best12. ;
    informat C40 $1. ;
    informat C41 $1. ;
    informat C42 $1. ;
    informat C43 $4. ;
    informat C44 $1. ;
    informat C45 best12. ;
    informat C46 $1. ;

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
    format C25 $2. ;
    format C26 $1. ;
    format C27 $1. ;
    format C28 $1. ;
    format C29 $1. ;
    format C30 $2. ;
    format C31 $1. ;
    format C32 $1. ;
    format C33 $6. ;
    format C34 $2. ;
    format C35 $2. ;
    format C36 $2. ;
    format C37 $1. ;
    format C38 $6. ;
    format C39 best12. ;
    format C40 $1. ;
    format C41 $1. ;
    format C42 $1. ;
    format C43 $4. ;
    format C44 $1. ;
    format C45 best12. ;
    format C46 $1. ;

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
        C39
        C40 $
        C41 $
        C42 $
        C43 $
        C44 $
        C45
        C46 $
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
        C9  = '지난1주간활동상태'
        C10 = '지난1주간취업여부'
        C11 = '일시휴직여부'
        C12 = '1개월간 구직활동 여부'
        C13 = '부업여부'
        C14 = '취업구분'
        C15 = '주업시간'
        C16 = '부업시간'
        C17 = '총취업시간'
        C18 = '취업가능성'
        C19 = '구직 주요경로1'
        C20 = '구직 주요경로2'
        C21 = '구직방법1'
        C22 = '구직방법2'
        C23 = '구직활동기간'
        C24 = '구직의사유무'
        C25 = '직장구하지않는이유'
        C26 = '구직활동유무'
        C27 = '구직분야'
        C28 = '구직종류'
        C29 = '희망직장지위'
        C30 = '근로종류'
        C31 = '희망월평균소득'
        C32 = '전직유무'
        C33 = '이직시기'
        C34 = '직장을그만둔이유'
        C35 = '산업코드'
        C36 = '직업코드'
        C37 = '종사상지위'
        C38 = '직업시작년월'
        C39 = '월평균임금'
        C40 = '고용계약여부'
        C41 = '고용계약기간'
        C42 = '직업교육훈련여부'
        C43 = '사업체소재지코드'
        C44 = '교육정도컨버전'
        C45 = '시군가중치'
        C46 = '경제활동구분'
    ;

run;


data job09;
set mdis;

year = 2009;

age = c4;
if age ge 20 and age le 39;
if      age ge 20 and age le 24 then ac=1;
else if age ge 25 and age le 29 then ac=2;
else if age ge 30 and age le 34 then ac=3;
else if age ge 35 and age le 39 then ac=4;

if input(vvalue(c46), best.) = 1; * 취업자;

wage = c39;
if wage = . then delete;

/* 2009 C43은 4자리 사업체소재지코드라서 2자리 시도 코드로 변환 */
area1_raw = input(vvalue(c43), best.);
area1 = floor(area1_raw / 100);

if area1_raw in (8888, 9999) then delete;
if area1 = . then delete;

/* ------------------------------------------------------------
   산업중분류(c35)를 산업대분류(job)로 재분류
   - c35: 9차 산업중분류
   - job: 산업대분류 코드 A~S
   - 2009는 9차 산업분류라 D=35~36, L=68~69, N=74~75임
------------------------------------------------------------ */

length job $1;

c35n = input(vvalue(c35), best.);

/* A. 농업, 임업 및 어업 */
if c35n in (1, 2, 3) then job = "A";

/* B. 광업 */
else if c35n in (5, 6, 7, 8) then job = "B";

/* C. 제조업 */
else if c35n in (10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
                 30, 31, 32, 33) then job = "C";

/* D. 전기, 가스, 증기 및 수도사업 */
else if c35n in (35, 36) then job = "D";

/* E. 하수·폐기물 처리, 원료재생 및 환경복원업 */
else if c35n in (37, 38, 39) then job = "E";

/* F. 건설업 */
else if c35n in (41, 42) then job = "F";

/* G. 도매 및 소매업 */
else if c35n in (45, 46, 47) then job = "G";

/* H. 운수업 */
else if c35n in (49, 50, 51, 52) then job = "H";

/* I. 숙박 및 음식점업 */
else if c35n in (55, 56) then job = "I";

/* J. 출판, 영상, 방송통신 및 정보서비스업 */
else if c35n in (58, 59, 60, 61, 62, 63) then job = "J";

/* K. 금융 및 보험업 */
else if c35n in (64, 65, 66) then job = "K";

/* L. 부동산업 및 임대업 */
else if c35n in (68, 69) then job = "L";

/* M. 전문, 과학 및 기술 서비스업 */
else if c35n in (70, 71, 72, 73) then job = "M";

/* N. 사업시설관리 및 사업지원 서비스업 */
else if c35n in (74, 75) then job = "N";

/* O. 공공행정, 국방 및 사회보장 행정 */
else if c35n in (84) then job = "O";

/* P. 교육 서비스업 */
else if c35n in (85) then job = "P";

/* Q. 보건업 및 사회복지 서비스업 */
else if c35n in (86, 87) then job = "Q";

/* R. 예술, 스포츠 및 여가관련 서비스업 */
else if c35n in (90, 91) then job = "R";

/* S. 협회 및 단체, 수리 및 기타 개인 서비스업 */
else if c35n in (94, 95, 96) then job = "S";

else job = ".";

if job = "." then delete;

wt = c45; * 시군가중치;

keep year age area1 wage job wt ac;
run;

/* ------------------------------------------------------------
   area1 × year × job별 평균임금 및 종사자수 산출 후 wide format 생성
   - wage_wide09  : area1-year별 job 평균임금
   - employ_wide09: area1-year별 job 가중 종사자수
------------------------------------------------------------ */

data job09_ready;
    set job09;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job09_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats09(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats09;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats09 out=wage_wide09(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats09 out=employ_wide09(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide09;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide09;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide09;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide09;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
