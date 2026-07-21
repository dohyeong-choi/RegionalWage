/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile "&KEUS\2010.csv"
        delimiter = ','
        MISSOVER
        DSD
        lrecl=32767
        firstobs = 2;

    informat C1 $4. ;
    informat C2 $1. ;
    informat C3 $1. ;
    informat C4 best12. ;
    informat C5 $1. ;
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
    informat C17 $3. ;
    informat C18 $3. ;
    informat C19 $3. ;
    informat C20 $1. ;
    informat C21 $2. ;
    informat C22 $2. ;
    informat C23 $2. ;
    informat C24 $2. ;
    informat C25 $2. ;
    informat C26 $1. ;
    informat C27 $2. ;
    informat C28 $1. ;
    informat C29 $1. ;
    informat C30 $2. ;
    informat C31 $1. ;
    informat C32 $2. ;
    informat C33 $1. ;
    informat C34 $1. ;
    informat C35 $6. ;
    informat C36 $2. ;
    informat C37 $2. ;
    informat C38 $2. ;
    informat C39 $1. ;
    informat C40 $6. ;
    informat C41 $4. ;
    informat C42 best12. ;
    informat C43 $1. ;
    informat C44 $1. ;
    informat C45 $4. ;
    informat C46 $1. ;
    informat C47 best12. ;
    informat C48 $1. ;

    format C1 $4. ;
    format C2 $1. ;
    format C3 $1. ;
    format C4 best12. ;
    format C5 $1. ;
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
    format C17 $3. ;
    format C18 $3. ;
    format C19 $3. ;
    format C20 $1. ;
    format C21 $2. ;
    format C22 $2. ;
    format C23 $2. ;
    format C24 $2. ;
    format C25 $2. ;
    format C26 $1. ;
    format C27 $2. ;
    format C28 $1. ;
    format C29 $1. ;
    format C30 $2. ;
    format C31 $1. ;
    format C32 $2. ;
    format C33 $1. ;
    format C34 $1. ;
    format C35 $6. ;
    format C36 $2. ;
    format C37 $2. ;
    format C38 $2. ;
    format C39 $1. ;
    format C40 $6. ;
    format C41 $4. ;
    format C42 best12. ;
    format C43 $1. ;
    format C44 $1. ;
    format C45 $4. ;
    format C46 $1. ;
    format C47 best12. ;
    format C48 $1. ;

    input
        C1 $
        C2 $
        C3 $
        C4
        C5 $
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
        C1 = '행정구역'
        C2 = '가구주와의 관계'
        C3 = '성별'
        C4 = '연령(만나이)'
        C5 = '5-1.교육정도(학력)'
        C6 = '5-2.계열(고등학교인 경우)'
        C7 = '5-3.계열(전문대 이상)'
        C8 = '5-4.교육정도(수학여부)'
        C9 = '6.혼인상태'
        C10 = '7.2009년 직업교육훈련 참여 여부'
        C11 = '8.지난1주간활동상태'
        C12 = '9.지난1주간취업여부'
        C13 = '10.일시휴직여부'
        C14 = '11.1개월간 구직활동 여부'
        C15 = '12.부업여부'
        C16 = '13.취업구분'
        C17 = '13-1.주업시간'
        C18 = '13-2.부업시간'
        C19 = '13-3.총취업시간'
        C20 = '14.즉시취업 가능여부(실업)'
        C21 = '15.1.1.구직 주요경로1'
        C22 = '15.1.2.구직 주요경로2'
        C23 = '15.2.1.구직방법1'
        C24 = '15.2.2.구직방법2'
        C25 = '16.구직활동기간'
        C26 = '17.구직희망여부'
        C27 = '18.직장구하지않은이유'
        C28 = '19.지난 1년간 구직활동여부'
        C29 = '20.희망직상 산업'
        C30 = '21.희망직상 직업'
        C31 = '22.희망직장지위'
        C32 = '22.1.근로종류'
        C33 = '23.희망월평균소득'
        C34 = '24.전직유무'
        C35 = '24.1.이직시기'
        C36 = '25.직장을그만둔이유'
        C37 = '26.산업코드'
        C38 = '27.직업코드'
        C39 = '28.종사상지위'
        C40 = '29.직장시작년월'
        C41 = '30.동일직업 근무기간'
        C42 = '31.3개월 평균임금'
        C43 = '32.고용계약여부'
        C44 = '32-1.고용계약기간'
        C45 = '사업체소재지코드'
        C46 = '교육정도컨버전'
        C47 = '시군가중치'
        C48 = '경제활동구분'
    ;

run;


data job10;
set mdis;

year = 2010;

age = c4;
if age ge 20 and age le 39;
if      age ge 20 and age le 24 then ac=1;
else if age ge 25 and age le 29 then ac=2;
else if age ge 30 and age le 34 then ac=3;
else if age ge 35 and age le 39 then ac=4;

if input(vvalue(c48), best.) = 1; * 취업자;

wage = c42;
if wage = . then delete;

/* 2010 C45는 4자리 시군 코드라서 2자리 시도 코드로 변환 */
area1_raw = input(vvalue(c45), best.);
area1 = floor(area1_raw / 100);

if area1_raw = 9998 then delete;
if area1 = . then delete;

/* ------------------------------------------------------------
   산업중분류(c37)를 산업대분류(job)로 재분류
   - c37: 9차 산업중분류
   - job: 산업대분류 코드 A~S
   - 2010은 9차 산업분류라 D=35~36, L=68~69, N=74~75임
------------------------------------------------------------ */

length job $1;

c37n = input(vvalue(c37), best.);

/* A. 농업, 임업 및 어업 */
if c37n in (1, 2, 3) then job = "A";

/* B. 광업 */
else if c37n in (5, 6, 7, 8) then job = "B";

/* C. 제조업 */
else if c37n in (10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
                 30, 31, 32, 33) then job = "C";

/* D. 전기, 가스, 증기 및 수도사업 */
else if c37n in (35, 36) then job = "D";

/* E. 하수·폐기물 처리, 원료재생 및 환경복원업 */
else if c37n in (37, 38, 39) then job = "E";

/* F. 건설업 */
else if c37n in (41, 42) then job = "F";

/* G. 도매 및 소매업 */
else if c37n in (45, 46, 47) then job = "G";

/* H. 운수업 */
else if c37n in (49, 50, 51, 52) then job = "H";

/* I. 숙박 및 음식점업 */
else if c37n in (55, 56) then job = "I";

/* J. 출판, 영상, 방송통신 및 정보서비스업 */
else if c37n in (58, 59, 60, 61, 62, 63) then job = "J";

/* K. 금융 및 보험업 */
else if c37n in (64, 65, 66) then job = "K";

/* L. 부동산업 및 임대업 */
else if c37n in (68, 69) then job = "L";

/* M. 전문, 과학 및 기술 서비스업 */
else if c37n in (70, 71, 72, 73) then job = "M";

/* N. 사업시설관리 및 사업지원 서비스업 */
else if c37n in (74, 75) then job = "N";

/* O. 공공행정, 국방 및 사회보장 행정 */
else if c37n in (84) then job = "O";

/* P. 교육 서비스업 */
else if c37n in (85) then job = "P";

/* Q. 보건업 및 사회복지 서비스업 */
else if c37n in (86, 87) then job = "Q";

/* R. 예술, 스포츠 및 여가관련 서비스업 */
else if c37n in (90, 91) then job = "R";

/* S. 협회 및 단체, 수리 및 기타 개인 서비스업 */
else if c37n in (94, 95, 96) then job = "S";

else job = ".";

if job = "." then delete;

wt = c47; * 시군가중치;

keep year age area1 wage job wt ac;
run;

/* ------------------------------------------------------------
   area1 × year × job별 평균임금 및 종사자수 산출 후 wide format 생성
   - wage_wide10  : area1-year별 job 평균임금
   - employ_wide10: area1-year별 job 가중 종사자수
------------------------------------------------------------ */

data job10_ready;
    set job10;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job10_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats10(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats10;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats10 out=wage_wide10(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats10 out=employ_wide10(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide10;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide10;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide10;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide10;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
