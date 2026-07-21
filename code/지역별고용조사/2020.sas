/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile "&KEUS\2020.csv"
        delimiter = ','
        MISSOVER
        DSD
        lrecl=32767
        firstobs = 2;

    informat C1 best12. ;
    informat C2 best12. ;
    informat C3 best12. ;
    informat C4 best12. ;
    informat C5 best12. ;
    informat C6 best12. ;
    informat C7 best12. ;
    informat C8 best12. ;
    informat C9 best12. ;
    informat C10 best12. ;
    informat C11 best12. ;
    informat C12 best12. ;
    informat C13 best12. ;
    informat C14 best12. ;
    informat C15 best12. ;
    informat C16 best12. ;
    informat C17 best12. ;
    informat C18 best12. ;
    informat C19 best12. ;
    informat C20 best12. ;
    informat C21 best12. ;
    informat C22 best12. ;
    informat C23 best12. ;
    informat C24 best12. ;
    informat C25 best12. ;
    informat C26 best12. ;
    informat C27 best12. ;
    informat C28 best12. ;
    informat C29 best12. ;
    informat C30 best12. ;
    informat C31 best12. ;
    informat C32 best12. ;
    informat C33 best12. ;
    informat C34 best12. ;
    informat C35 best12. ;
    informat C36 best12. ;
    informat C37 best12. ;
    informat C38 best12. ;
    informat C39 best12. ;
    informat C40 best12. ;
    informat C41 best12. ;
    informat C42 best12. ;
    informat C43 best12. ;
    informat C44 best12. ;
    informat C45 best12. ;
    informat C46 best12. ;
    informat C47 best12. ;
    informat C48 best12. ;
    informat C49 best12. ;
    informat C50 best12. ;
    informat C51 best12. ;
    informat C52 best12. ;
    informat C53 best12. ;
    informat C54 best12. ;
    informat C55 best12. ;
    informat C56 best12. ;

    format C1 best12. ;
    format C2 best12. ;
    format C3 best12. ;
    format C4 best12. ;
    format C5 best12. ;
    format C6 best12. ;
    format C7 best12. ;
    format C8 best12. ;
    format C9 best12. ;
    format C10 best12. ;
    format C11 best12. ;
    format C12 best12. ;
    format C13 best12. ;
    format C14 best12. ;
    format C15 best12. ;
    format C16 best12. ;
    format C17 best12. ;
    format C18 best12. ;
    format C19 best12. ;
    format C20 best12. ;
    format C21 best12. ;
    format C22 best12. ;
    format C23 best12. ;
    format C24 best12. ;
    format C25 best12. ;
    format C26 best12. ;
    format C27 best12. ;
    format C28 best12. ;
    format C29 best12. ;
    format C30 best12. ;
    format C31 best12. ;
    format C32 best12. ;
    format C33 best12. ;
    format C34 best12. ;
    format C35 best12. ;
    format C36 best12. ;
    format C37 best12. ;
    format C38 best12. ;
    format C39 best12. ;
    format C40 best12. ;
    format C41 best12. ;
    format C42 best12. ;
    format C43 best12. ;
    format C44 best12. ;
    format C45 best12. ;
    format C46 best12. ;
    format C47 best12. ;
    format C48 best12. ;
    format C49 best12. ;
    format C50 best12. ;
    format C51 best12. ;
    format C52 best12. ;
    format C53 best12. ;
    format C54 best12. ;
    format C55 best12. ;
    format C56 best12. ;

    input
        C1
        C2
        C3
        C4
        C5
        C6
        C7
        C8
        C9
        C10
        C11
        C12
        C13
        C14
        C15
        C16
        C17
        C18
        C19
        C20
        C21
        C22
        C23
        C24
        C25
        C26
        C27
        C28
        C29
        C30
        C31
        C32
        C33
        C34
        C35
        C36
        C37
        C38
        C39
        C40
        C41
        C42
        C43
        C44
        C45
        C46
        C47
        C48
        C49
        C50
        C51
        C52
        C53
        C54
        C55
        C56
    ;

run;

data job20;
set mdis;

year=2020; 
age=c4;
if age ge 20 and age le 39;

if c52=1; * 취업자;
wage=c31;
if wage=. then delete;
area1=c19;

/* ------------------------------------------------------------
   산업중분류(c20)를 산업대분류(job)로 재분류
   - c20: 2자리_11차산업중분류코드
   - job: 산업대분류 코드 A~S
   - S까지만 분류하고, 그 외 값은 결측 처리
   - vvalue(c20)를 사용하여 c20이 문자형/숫자형이어도 처리 가능
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

/* D. 전기, 가스, 증기 및 공기 조절 공급업 */
else if c20n in (35) then job = "D";

/* E. 수도, 하수 및 폐기물 처리, 원료 재생업 */
else if c20n in (36, 37, 38, 39) then job = "E";

/* F. 건설업 */
else if c20n in (41, 42) then job = "F";

/* G. 도매 및 소매업 */
else if c20n in (45, 46, 47) then job = "G";

/* H. 운수 및 창고업 */
else if c20n in (49, 50, 51, 52) then job = "H";

/* I. 숙박 및 음식점업 */
else if c20n in (55, 56) then job = "I";

/* J. 정보통신업 */
else if c20n in (58, 59, 60, 61, 62, 63) then job = "J";

/* K. 금융 및 보험업 */
else if c20n in (64, 65, 66) then job = "K";

/* L. 부동산업 */
else if c20n in (68) then job = "L";

/* M. 전문, 과학 및 기술 서비스업 */
else if c20n in (70, 71, 72, 73) then job = "M";

/* N. 사업시설 관리, 사업 지원 및 임대 서비스업 */
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

/* A~S에 해당하지 않는 산업중분류 코드는 결측 처리 */
else job = ".";
if job="." then delete;

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
data job20_ready;
    set job20;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job20_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats20(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats20;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats20 out=wage_wide20(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats20 out=employ_wide20(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide20;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide20;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide20;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide20;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
