/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile "&KEUS\2013.csv"
        delimiter = ','
        MISSOVER
        DSD
        lrecl=32767
        firstobs = 2;

    informat C1 $6. ;
    informat C2 $1. ;
    informat C3 $1. ;
    informat C4 best12. ;
    informat C5 $1. ;
    informat C6 $1. ;
    informat C7 $1. ;
    informat C8 $1. ;
    informat C9 $1. ;
    informat C10 $2. ;
    informat C11 $1. ;
    informat C12 $2. ;
    informat C13 $1. ;
    informat C14 $1. ;
    informat C15 best12. ;
    informat C16 $1. ;
    informat C17 best12. ;
    informat C18 best12. ;
    informat C19 $2. ;
    informat C20 $1. ;
    informat C21 $2. ;
    informat C22 $2. ;
    informat C23 $2. ;
    informat C24 $2. ;
    informat C25 $1. ;
    informat C26 $2. ;
    informat C27 $2. ;
    informat C28 $6. ;
    informat C29 best12. ;
    informat C30 $1. ;
    informat C31 $2. ;
    informat C32 $1. ;
    informat C33 $1. ;
    informat C34 $1. ;
    informat C35 $2. ;
    informat C36 $1. ;
    informat C37 $2. ;
    informat C38 $6. ;
    informat C39 $2. ;
    informat C40 $1. ;
    informat C41 best12. ;
    informat C42 $4. ;
    informat C43 $2. ;
    informat C44 $1. ;
    informat C45 $1. ;
    informat C46 $1. ;
    informat C47 $1. ;
    informat C48 $1. ;
    informat C49 $1. ;
    informat C50 $2. ;
    informat C51 best12. ;
    informat C52 $1. ;
    informat C53 $1. ;

    format C1 $6. ;
    format C2 $1. ;
    format C3 $1. ;
    format C4 best12. ;
    format C5 $1. ;
    format C6 $1. ;
    format C7 $1. ;
    format C8 $1. ;
    format C9 $1. ;
    format C10 $2. ;
    format C11 $1. ;
    format C12 $2. ;
    format C13 $1. ;
    format C14 $1. ;
    format C15 best12. ;
    format C16 $1. ;
    format C17 best12. ;
    format C18 best12. ;
    format C19 $2. ;
    format C20 $1. ;
    format C21 $2. ;
    format C22 $2. ;
    format C23 $2. ;
    format C24 $2. ;
    format C25 $1. ;
    format C26 $2. ;
    format C27 $2. ;
    format C28 $6. ;
    format C29 best12. ;
    format C30 $1. ;
    format C31 $2. ;
    format C32 $1. ;
    format C33 $1. ;
    format C34 $1. ;
    format C35 $2. ;
    format C36 $1. ;
    format C37 $2. ;
    format C38 $6. ;
    format C39 $2. ;
    format C40 $1. ;
    format C41 best12. ;
    format C42 $4. ;
    format C43 $2. ;
    format C44 $1. ;
    format C45 $1. ;
    format C46 $1. ;
    format C47 $1. ;
    format C48 $1. ;
    format C49 $1. ;
    format C50 $2. ;
    format C51 best12. ;
    format C52 $1. ;
    format C53 $1. ;

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
        C15
        C16 $
        C17
        C18
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
        C29
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
        C41
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

    label
        C1 = '조사연월'
        C2 = '가구주관계코드'
        C3 = '성별코드'
        C4 = '만연령'
        C5 = '교육정도코드'
        C6 = '교육정도_고등학교계열코드'
        C7 = '교육정도_전문대이상계열코드'
        C8 = '교육정도_수학구분코드'
        C9 = '혼인상태코드'
        C10 = '활동상태코드'
        C11 = '조사대상주간 일여부(자신의 수입 있는 일)^ 무급가족일 여부(가족의 무급일)'
        C12 = '조사대상주간_일시휴직사유코드'
        C13 = '4주간구직활동여부'
        C14 = '조사대상주간_부업여부'
        C15 = '조사대상주간_주업근무시간수'
        C16 = '주업부업총계시간구분코드'
        C17 = '조사대상주간_부업근무시간수'
        C18 = '조사대상주간_근무총계시간수'
        C19 = '근무사업체소재지코드'
        C20 = '조사대상주간_취업가능여부'
        C21 = '현직장산업(10차중분류)'
        C22 = '1순위구직경로코드'
        C23 = '2순위구직경로코드'
        C24 = '2자리_7차직업중분류코드'
        C25 = '종사상지위코드'
        C26 = '1순위구직방법코드'
        C27 = '2순위구직방법코드'
        C28 = '조사대상주간_직장시작연월'
        C29 = '구직활동기간월수'
        C30 = '조사대상주간_취업희망여부'
        C31 = '지난4주간비구직사유코드'
        C32 = '고용계약기간정함여부'
        C33 = '고용계약기간코드'
        C34 = '지난1년간구직경험여부'
        C35 = '연금가입구분코드'
        C36 = '수입목적직업경험여부'
        C37 = '건강보험가입구분코드'
        C38 = '1년미만이전직장_퇴직년월'
        C39 = '고용보험가입여부'
        C40 = '수입목적직업_퇴직시기_1년이상_만54세구분코드'
        C41 = '최근3개월_월평균급여'
        C42 = '수입목적직업_퇴직시기_1년이상_만54세이하_년수'
        C43 = '퇴직사유코드'
        C44 = '퇴직사유_가사사유코드'
        C45 = '이전직장_근무기간구분코드'
        C46 = '지난1년간_직업교육훈련참여여부'
        C47 = '교육훈련기관구분1코드'
        C48 = '교육훈련기관구분2코드'
        C49 = '주된도움_직업교육훈련구분코드'
        C50 = '행정구역시도코드'
        C51 = '시도전국가중값'
        C52 = '경제활동인구상태코드'
        C53 = '교육정도변환코드'
    ;

run;


data job13;
set mdis;

year = 2013;

age = c4;
if age ge 20 and age le 39;

if input(vvalue(c52), best.) = 1; * 취업자;

wage = c41;
if wage = . then delete;

area1 = input(vvalue(c19), best.);

/* ------------------------------------------------------------
   산업중분류(c21)를 산업대분류(job)로 재분류
   - c21: 현직장산업(10차중분류)
   - job: 산업대분류 코드 A~S
------------------------------------------------------------ */

length job $1;

c21n = input(vvalue(c21), best.);

/* A. 농업, 임업 및 어업 */
if c21n in (1, 2, 3) then job = "A";

/* B. 광업 */
else if c21n in (5, 6, 7, 8) then job = "B";

/* C. 제조업 */
else if c21n in (10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
                 30, 31, 32, 33, 34) then job = "C";

/* D. 전기, 가스, 증기 및 공기 조절 공급업 */
else if c21n in (35) then job = "D";

/* E. 수도, 하수 및 폐기물 처리, 원료 재생업 */
else if c21n in (36, 37, 38, 39) then job = "E";

/* F. 건설업 */
else if c21n in (41, 42) then job = "F";

/* G. 도매 및 소매업 */
else if c21n in (45, 46, 47) then job = "G";

/* H. 운수 및 창고업 */
else if c21n in (49, 50, 51, 52) then job = "H";

/* I. 숙박 및 음식점업 */
else if c21n in (55, 56) then job = "I";

/* J. 정보통신업 */
else if c21n in (58, 59, 60, 61, 62, 63) then job = "J";

/* K. 금융 및 보험업 */
else if c21n in (64, 65, 66) then job = "K";

/* L. 부동산업 */
else if c21n in (68) then job = "L";

/* M. 전문, 과학 및 기술 서비스업 */
else if c21n in (70, 71, 72, 73) then job = "M";

/* N. 사업시설 관리, 사업 지원 및 임대 서비스업 */
else if c21n in (74, 75, 76) then job = "N";

/* O. 공공행정, 국방 및 사회보장 행정 */
else if c21n in (84) then job = "O";

/* P. 교육 서비스업 */
else if c21n in (85) then job = "P";

/* Q. 보건업 및 사회복지 서비스업 */
else if c21n in (86, 87) then job = "Q";

/* R. 예술, 스포츠 및 여가관련 서비스업 */
else if c21n in (90, 91) then job = "R";

/* S. 협회 및 단체, 수리 및 기타 개인 서비스업 */
else if c21n in (94, 95, 96) then job = "S";

else job = ".";

if job = "." then delete;

wt = c51; * 시도전국가중값;

if      age ge 20 and age le 24 then ac=1;
else if age ge 25 and age le 29 then ac=2;
else if age ge 30 and age le 34 then ac=3;
else if age ge 35 and age le 39 then ac=4;

keep year age area1 wage job wt ac;
run;

/* ------------------------------------------------------------
   area1 × year × job별 평균임금 및 종사자수 산출 후 wide format 생성
   - wage_wide13  : area1-year별 job 평균임금
   - employ_wide13: area1-year별 job 가중 종사자수
------------------------------------------------------------ */

data job13_ready;
    set job13;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job13_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats13(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats13;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats13 out=wage_wide13(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats13 out=employ_wide13(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide13;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide13;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide13;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide13;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
