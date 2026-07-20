data WORK.MDIS;
    %let _EFIERR_ = 0;

    infile 'D:\이경재\학술대회 및 논문공모전\2027 Journal of Regional Science\분석\지역별 고용조사\2018.csv'
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
    informat C6 $2. ;
    informat C7 $2. ;
    informat C8 $1. ;
    informat C9 $1. ;
    informat C10 $2. ;
    informat C11 $1. ;
    informat C12 $1. ;
    informat C13 $1. ;
    informat C14 $1. ;
    informat C15 $1. ;
    informat C16 $1. ;
    informat C17 best12. ;
    informat C18 $1. ;
    informat C19 best12. ;
    informat C20 best12. ;
    informat C21 $2. ;
    informat C22 $1. ;
    informat C23 $1. ;
    informat C24 $1. ;
    informat C25 $2. ;
    informat C26 $1. ;
    informat C27 $1. ;
    informat C28 $2. ;
    informat C29 $1. ;
    informat C30 $6. ;
    informat C31 $1. ;
    informat C32 best12. ;
    informat C33 $1. ;
    informat C34 $1. ;
    informat C35 $2. ;
    informat C36 $1. ;
    informat C37 $1. ;
    informat C38 $1. ;
    informat C39 $2. ;
    informat C40 $1. ;
    informat C41 $2. ;
    informat C42 $6. ;
    informat C43 $2. ;
    informat C44 $2. ;
    informat C45 best12. ;
    informat C46 $4. ;
    informat C47 $2. ;
    informat C48 $1. ;
    informat C49 $1. ;
    informat C50 $2. ;
    informat C51 best12. ;
    informat C52 $1. ;
    informat C53 $1. ;
    informat C54 best12. ;
    informat C55 best12. ;

    format C1 $6. ;
    format C2 $1. ;
    format C3 $1. ;
    format C4 best12. ;
    format C5 $1. ;
    format C6 $2. ;
    format C7 $2. ;
    format C8 $1. ;
    format C9 $1. ;
    format C10 $2. ;
    format C11 $1. ;
    format C12 $1. ;
    format C13 $1. ;
    format C14 $1. ;
    format C15 $1. ;
    format C16 $1. ;
    format C17 best12. ;
    format C18 $1. ;
    format C19 best12. ;
    format C20 best12. ;
    format C21 $2. ;
    format C22 $1. ;
    format C23 $1. ;
    format C24 $1. ;
    format C25 $2. ;
    format C26 $1. ;
    format C27 $1. ;
    format C28 $2. ;
    format C29 $1. ;
    format C30 $6. ;
    format C31 $1. ;
    format C32 best12. ;
    format C33 $1. ;
    format C34 $1. ;
    format C35 $2. ;
    format C36 $1. ;
    format C37 $1. ;
    format C38 $1. ;
    format C39 $2. ;
    format C40 $1. ;
    format C41 $2. ;
    format C42 $6. ;
    format C43 $2. ;
    format C44 $2. ;
    format C45 best12. ;
    format C46 $4. ;
    format C47 $2. ;
    format C48 $1. ;
    format C49 $1. ;
    format C50 $2. ;
    format C51 best12. ;
    format C52 $1. ;
    format C53 $1. ;
    format C54 best12. ;
    format C55 best12. ;

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
        C17
        C18 $
        C19
        C20
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
        C32
        C33 $
        C34 $
        C35 $
        C36 $
        C37 $
        C38 $
        C39 $
        C40 $
        C41 $
        C42 $
        C43 $
        C44 $
        C45
        C46 $
        C47 $
        C48 $
        C49 $
        C50 $
        C51
        C52 $
        C53 $
        C54
        C55
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
        C11 = '조사대상주간_수입목적종사여부'
        C12 = '조사대상주간_가족무급종사여부'
        C13 = '조사대상주간_일시휴직여부'
        C14 = '조사대상주간_일시휴직사유코드'
        C15 = '4주간구직활동여부'
        C16 = '조사대상주간_부업여부'
        C17 = '조사대상주간_주업근무시간수'
        C18 = '주업부업총계시간구분코드'
        C19 = '조사대상주간_부업근무시간수'
        C20 = '조사대상주간_근무총계시간수'
        C21 = '근무사업체소재지코드'
        C22 = '조사대상주간_취업가능여부'
        C23 = '1순위구직경로코드'
        C24 = '2순위구직경로코드'
        C25 = '2자리_11차산업중분류코드'
        C26 = '종사상지위코드'
        C27 = '1순위구직방법코드'
        C28 = '2자리_8차직업중분류코드'
        C29 = '2순위구직방법코드'
        C30 = '조사대상주간_직장시작연월'
        C31 = '취업여성_경력단절경험여부'
        C32 = '구직활동기간월수'
        C33 = '취업여성_경력단절사유코드'
        C34 = '조사대상주간_취업희망여부'
        C35 = '지난4주간비구직사유코드'
        C36 = '고용계약기간정함여부'
        C37 = '고용계약기간코드'
        C38 = '지난1년간구직경험여부'
        C39 = '연금가입구분코드'
        C40 = '수입목적직업경험여부'
        C41 = '건강보험가입구분코드'
        C42 = '1년미만이전직장_퇴직년월'
        C43 = '고용보험가입여부'
        C44 = '수입목적직업_퇴직시기_1년이상_만54세구분코드'
        C45 = '최근3개월_월평균급여'
        C46 = '수입목적직업_퇴직시기_1년이상_만54세이하_년수'
        C47 = '퇴직사유코드'
        C48 = '퇴직사유_가사사유코드'
        C49 = '수입목적직업_퇴직시기구분코드'
        C50 = '행정구역시도코드'
        C51 = '시도전국가중값'
        C52 = '경제활동인구상태코드'
        C53 = '교육정도변환코드'
        C54 = '막내자녀연령'
        C55 = '18세미만자녀수'
    ;

run;


data job18;
set mdis;

year = 2018;

age = c4;
if age ge 20 and age le 39;

if input(vvalue(c52), best.) = 1; * 취업자;

wage = c45;
if wage = . then delete;

area1 = input(vvalue(c21), best.);

/* ------------------------------------------------------------
   산업중분류(c25)를 산업대분류(job)로 재분류
   - c25: 2자리_11차산업중분류코드
   - job: 산업대분류 코드 A~S
------------------------------------------------------------ */

length job $1;

c25n = input(vvalue(c25), best.);

/* A. 농업, 임업 및 어업 */
if c25n in (1, 2, 3) then job = "A";

/* B. 광업 */
else if c25n in (5, 6, 7, 8) then job = "B";

/* C. 제조업 */
else if c25n in (10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
                 30, 31, 32, 33, 34) then job = "C";

/* D. 전기, 가스, 증기 및 공기 조절 공급업 */
else if c25n in (35) then job = "D";

/* E. 수도, 하수 및 폐기물 처리, 원료 재생업 */
else if c25n in (36, 37, 38, 39) then job = "E";

/* F. 건설업 */
else if c25n in (41, 42) then job = "F";

/* G. 도매 및 소매업 */
else if c25n in (45, 46, 47) then job = "G";

/* H. 운수 및 창고업 */
else if c25n in (49, 50, 51, 52) then job = "H";

/* I. 숙박 및 음식점업 */
else if c25n in (55, 56) then job = "I";

/* J. 정보통신업 */
else if c25n in (58, 59, 60, 61, 62, 63) then job = "J";

/* K. 금융 및 보험업 */
else if c25n in (64, 65, 66) then job = "K";

/* L. 부동산업 */
else if c25n in (68) then job = "L";

/* M. 전문, 과학 및 기술 서비스업 */
else if c25n in (70, 71, 72, 73) then job = "M";

/* N. 사업시설 관리, 사업 지원 및 임대 서비스업 */
else if c25n in (74, 75, 76) then job = "N";

/* O. 공공행정, 국방 및 사회보장 행정 */
else if c25n in (84) then job = "O";

/* P. 교육 서비스업 */
else if c25n in (85) then job = "P";

/* Q. 보건업 및 사회복지 서비스업 */
else if c25n in (86, 87) then job = "Q";

/* R. 예술, 스포츠 및 여가관련 서비스업 */
else if c25n in (90, 91) then job = "R";

/* S. 협회 및 단체, 수리 및 기타 개인 서비스업 */
else if c25n in (94, 95, 96) then job = "S";

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
   - wage_wide18  : area1-year별 job 평균임금
   - employ_wide18: area1-year별 job 가중 종사자수
------------------------------------------------------------ */

data job18_ready;
    set job18;
    job_l = lowcase(job);
    one = 1;
run;

proc summary data=job18_ready nway;
    class area1 year ac job_l;   /* ← ac 추가가 핵심 */
    var wage one;
    weight wt;
    output out=cell_stats18(drop=_TYPE_ _FREQ_)
        mean(wage) = mean_wage
        sum(one)   = employ;
run;

proc sort data=cell_stats18;
    by area1 year ac;            /* ← ac 추가 */
run;

proc transpose data=cell_stats18 out=wage_wide18(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var mean_wage;
run;

proc transpose data=cell_stats18 out=employ_wide18(drop=_NAME_);
    by area1 year ac;            /* ← ac 추가 */
    id job_l;
    var employ;
run;


/* ── 결측 → 0 (원본과 동일, retain에 ac 추가) ── */
data wage_wide18;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set wage_wide18;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;

data employ_wide18;
    retain area1 year ac a b c d e f g h i j k l m n o p q r s;
    set employ_wide18;
    array jobs[19] a b c d e f g h i j k l m n o p q r s;
    do _i = 1 to dim(jobs);
        if missing(jobs[_i]) then jobs[_i] = 0;
    end;
    drop _i;
run;
