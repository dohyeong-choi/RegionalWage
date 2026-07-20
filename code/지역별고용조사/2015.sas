/**********************************************************************
 *   PRODUCT:   SAS
 *   VERSION:   9.1
 *   CREATOR:   External File Interface
 *   DATE:      04OCT07
 *   DESC:      Generated SAS Datastep Code
 **********************************************************************/

data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile 'D:\이경재\학술대회 및 논문공모전\2027 Journal of Regional Science\분석\지역별 고용조사\2015.csv'
        delimiter = ','
        MISSOVER
        DSD
        lrecl = 32767
        firstobs = 2;

    informat C1  $18. ;
    informat C2  $1. ;
    informat C3  $2. ;
    informat C4  best12. ;
    informat C5  $1. ;
    informat C6  $1. ;
    informat C7  $1. ;
    informat C8  $1. ;
    informat C9  $1. ;
    informat C10 $1. ;
    informat C11 $1. ;
    informat C12 $1. ;
    informat C13 $1. ;
    informat C14 $1. ;
    informat C15 best12. ;
    informat C16 best12. ;
    informat C17 best12. ;
    informat C18 $1. ;
    informat C19 $2. ;
    informat C20 $2. ;
    informat C21 $2. ;
    informat C22 $3. ;
    informat C23 $6. ;
    informat C24 $1. ;
    informat C25 $3. ;
    informat C26 $1. ;
    informat C27 $1. ;
    informat C28 $2. ;
    informat C29 $2. ;
    informat C30 $2. ;
    informat C31 best12. ;
    informat C32 $1. ;
    informat C33 $1. ;
    informat C34 $1. ;
    informat C35 $1. ;
    informat C36 $1. ;
    informat C37 $1. ;
    informat C38 best12. ;
    informat C39 $1. ;
    informat C40 $2. ;
    informat C41 $1. ;
    informat C42 $2. ;
    informat C43 $1. ;
    informat C44 $1. ;
    informat C45 $6. ;
    informat C46 $2. ;
    informat C47 $4. ;
    informat C48 $2. ;
    informat C49 $1. ;
    informat C50 $2. ;
    informat C51 best12. ;
    informat C52 $1. ;
    informat C53 $1. ;

    format C1  $18. ;
    format C2  $1. ;
    format C3  $2. ;
    format C4  best12. ;
    format C5  $1. ;
    format C6  $1. ;
    format C7  $1. ;
    format C8  $1. ;
    format C9  $1. ;
    format C10 $1. ;
    format C11 $1. ;
    format C12 $1. ;
    format C13 $1. ;
    format C14 $1. ;
    format C15 best12. ;
    format C16 best12. ;
    format C17 best12. ;
    format C18 $1. ;
    format C19 $2. ;
    format C20 $2. ;
    format C21 $2. ;
    format C22 $3. ;
    format C23 $6. ;
    format C24 $1. ;
    format C25 $3. ;
    format C26 $1. ;
    format C27 $1. ;
    format C28 $2. ;
    format C29 $2. ;
    format C30 $2. ;
    format C31 best12. ;
    format C32 $1. ;
    format C33 $1. ;
    format C34 $1. ;
    format C35 $1. ;
    format C36 $1. ;
    format C37 $1. ;
    format C38 best12. ;
    format C39 $1. ;
    format C40 $2. ;
    format C41 $1. ;
    format C42 $2. ;
    format C43 $1. ;
    format C44 $1. ;
    format C45 $6. ;
    format C46 $2. ;
    format C47 $4. ;
    format C48 $2. ;
    format C49 $1. ;
    format C50 $2. ;
    format C51 best12. ;
    format C52 $1. ;
    format C53 $1. ;

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
        C15
        C16
        C17
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
        C31
        C32 $
        C33 $
        C34 $
        C35 $
        C36 $
        C37 $
        C38
        C39 $
        C40 $
        C41 $
        C42 $
        C43 $
        C44 $
        C45 $
        C46 $
        C47 $
        C48 $
        C49 $
        C50 $
        C51
        C52 $
        C53 $
    ;

run;


data job15;
set mdis;
age=c4;
if age ge 20 and age le 39;

if c52=1; * 취업자;
wage=c31;
if wage=. then delete;
area1=input(c19, 10.);
year=2015;
/* ------------------------------------------------------------
   2015년 산업중분류(c20)를 산업대분류(job)로 재분류
   - c20: 2자리_10차산업중분류코드
   - job: 산업대분류 코드 A~S
   - T(97~98), U(99)는 분석에서 제외
------------------------------------------------------------ */

length job $1;

/* c20을 숫자형으로 통일 */
c20n = input(vvalue(c20), best.);

/* A. 농업, 임업 및 어업 */
if c20n in (1, 2, 3) then job = "A";

/* B. 광업 */
else if c20n in (5, 6, 7, 8) then job = "B";

/* C. 제조업 */
else if c20n in (10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
                 30, 31, 32, 33, 34) then job = "C";

/* D. 전기, 가스, 증기 및 수도사업 */
else if c20n in (35) then job = "D";

/* E. 하수·폐기물 처리, 원료재생 및 환경복원업 */
else if c20n in (36, 37, 38, 39) then job = "E";

/* F. 건설업 */
else if c20n in (41, 42) then job = "F";

/* G. 도매 및 소매업 */
else if c20n in (45, 46, 47) then job = "G";

/* H. 운수업 */
else if c20n in (49, 50, 51, 52) then job = "H";

/* I. 숙박 및 음식점업 */
else if c20n in (55, 56) then job = "I";

/* J. 출판, 영상, 방송통신 및 정보서비스업 */
else if c20n in (58, 59, 60, 61, 62, 63) then job = "J";

/* K. 금융 및 보험업 */
else if c20n in (64, 65, 66) then job = "K";

/* L. 부동산업 및 임대업 */
else if c20n in (68) then job = "L";

/* M. 전문, 과학 및 기술 서비스업 */
else if c20n in (70, 71, 72, 73) then job = "M";

/* N. 사업시설관리 및 사업지원 서비스업 */
else if c20n in (74, 75, 76) then job = "N";

/* O. 공공행정, 국방 및 사회보장 행정 */
else if c20n in (84) then job = "O";

/* P. 교육 서비스업 */
else if c20n in (85) then job = "P";

/* Q. 보건업 및 사회복지 서비스업 */
else if c20n in (86, 87) then job = "Q";

/* R. 예술, 스포츠 및 여가관련 서비스업 */
else if c20n in (90, 91) then job = "R";

/* S. 협회 및 단체, 수리 및 기타 개인 서비스업 */
else if c20n in (94, 95, 96) then job = "S";

/* T, U 및 기타 코드는 제외 */
else job = ".";
if job = "." then delete;

wt=c51; * 시도전국가중값;

if      age ge 20 and age le 24 then ac=1;
else if age ge 25 and age le 29 then ac=2;
else if age ge 30 and age le 34 then ac=3;
else if age ge 35 and age le 39 then ac=4;

keep year age area1 wage job wt ac;
run;


/* ------------------------------------------------------------
   area1 × job별 평균임금 및 종사자수 산출 후 wide format 저장
   - wage 시트: area1별 job 평균임금
   - employ 시트: area1별 job 가중 종사자수
------------------------------------------------------------ */

/* job을 소문자로 변환: A~S -> a~s */
data job15_ready;
    set job15;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job15_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats15(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats15;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats15 out=wage_wide15(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats15 out=employ_wide15(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide15;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide15;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide15;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide15;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
