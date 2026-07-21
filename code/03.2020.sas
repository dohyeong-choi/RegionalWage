/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
libname lkj "&DATA";

data d20;
set lkj.GP19__2020;

/* 대학소재지 */
if g191area=1 then college_area=11; * 서울;
if g191area=2 then college_area=21; * 부산;
if g191area=3 then college_area=22; * 대구;
if g191area=4 then college_area=25; * 대전;
if g191area=5 then college_area=23; * 인천;
if g191area=6 then college_area=24; * 광주;
if g191area=7 then college_area=26; * 울산;
if g191area=8 then college_area=31; * 경기;
if g191area=9 then college_area=32; * 강원;
if g191area=10 then college_area=33; * 충북;
if g191area=11 then college_area=34; * 충남;
if g191area=12 then college_area=35; * 전북;
if g191area=13 then college_area=36; * 전남;
if g191area=14 then college_area=37; * 경북;
if g191area=15 then college_area=38; * 경남;
if g191area=16 then college_area=39; * 제주;
if g191area=17 then college_area=29; * 세종;

/* 고교소재지 */
if g191f006=1 then high_area=11; * 서울;
if g191f006=2 then high_area=21; * 부산;
if g191f006=3 then high_area=22; * 대구;
if g191f006=4 then high_area=25; * 대전;
if g191f006=5 then high_area=23; * 인천;
if g191f006=6 then high_area=24; * 광주;
if g191f006=7 then high_area=26; * 울산;
if g191f006=8 then high_area=31; * 경기;
if g191f006=9 then high_area=32; * 강원;
if g191f006=10 then high_area=33; * 충북;
if g191f006=11 then high_area=34; * 충남;
if g191f006=12 then high_area=35; * 전북;
if g191f006=13 then high_area=36; * 전남;
if g191f006=14 then high_area=37; * 경북;
if g191f006=15 then high_area=38; * 경남;
if g191f006=16 then high_area=39; * 제주;
if g191f006=17 then high_area=29; * 세종;

/* 첫직장 위치: 현직장=첫직장이면 A파트, 이직자면 D파트 */
if g191a388=1 then first_sido = g191a014;  * 현 직장이 첫 직장;
else               first_sido = g191d020;  * 이직자: D파트 첫 직장;
if first_sido in (-1, .) then delete;      * 모름/무응답/결측 제외;

/* 첫직장소재지 */
if first_sido=1  then c_area=11; * 서울;
if first_sido=2  then c_area=21; * 부산;
if first_sido=3  then c_area=22; * 대구;
if first_sido=4  then c_area=25; * 대전;
if first_sido=5  then c_area=23; * 인천;
if first_sido=6  then c_area=24; * 광주;
if first_sido=7  then c_area=26; * 울산;
if first_sido=8  then c_area=31; * 경기;
if first_sido=9  then c_area=32; * 강원;
if first_sido=10 then c_area=33; * 충북;
if first_sido=11 then c_area=34; * 충남;
if first_sido=12 then c_area=35; * 전북;
if first_sido=13 then c_area=36; * 전남;
if first_sido=14 then c_area=37; * 경북;
if first_sido=15 then c_area=38; * 경남;
if first_sido=16 then c_area=39; * 제주;
if first_sido=17 then c_area=29; * 세종;
if c_area=. then delete;

gender=0;
if g191sex=1 then gender=1; * 남성;

age=2020-g191birthy; *연령;
if age ge 20 and age le 39;
if age ge 20 and age le 24 then ac=1;
if age ge 25 and age le 29 then ac=2;
if age ge 30 and age le 34 then ac=3;
if age ge 35 and age le 39 then ac=4;

edu=0;
if g191school in (2 3 ) then edu=1; *교육대+4년제, 전문대는 edu=0;

major=0;
if g191majorcat in (4 5) then major=1; * 자연+공학 전공;

marry=0;
if g191p001=2 then marry=1; * 기혼;

/* 첫직장 산업: 현직장=첫직장이면 A파트, 이직자면 D파트 */
if g191a388=1 then first_ind = g191a004_10;   * 현 직장이 첫 직장;
else               first_ind = g191d007_10;   * 이직자: D파트 첫 직장 산업;
if first_ind in (-1, .) then delete;          * 모름/무응답/결측 제외;

if first_ind=1  then job='A';  /* 농업, 임업 및 어업 */
if first_ind=2  then job='B';  /* 광업 */
if first_ind=3  then job='C';  /* 제조업 */
if first_ind=4  then job='D';  /* 전기, 가스, 증기 및 공기 조절 공급업 */
if first_ind=5  then job='E';  /* 수도, 하수 및 폐기물 처리, 원료 재생업 */
if first_ind=6  then job='F';  /* 건설업 */
if first_ind=7  then job='G';  /* 도매 및 소매업 */
if first_ind=8  then job='H';  /* 운수 및 창고업 */
if first_ind=9  then job='I';  /* 숙박 및 음식점업 */
if first_ind=10 then job='J';  /* 정보통신업 */
if first_ind=11 then job='K';  /* 금융 및 보험업 */
if first_ind=12 then job='L';  /* 부동산업 */
if first_ind=13 then job='M';  /* 전문, 과학 및 기술 서비스업 */
if first_ind=14 then job='N';  /* 사업시설 관리, 사업 지원 및 임대 서비스업 */
if first_ind=15 then job='O';  /* 공공행정, 국방 및 사회보장 행정 */
if first_ind=16 then job='P';  /* 교육 서비스업 */
if first_ind=17 then job='Q';  /* 보건업 및 사회복지 서비스업 */
if first_ind=18 then job='R';  /* 예술, 스포츠 및 여가관련 서비스업 */
if first_ind=19 then job='S';  /* 협회 및 단체, 수리 및 기타 개인 서비스업 */
if first_ind=20 then job='T';  /* 가구 내 고용활동 등 */
if first_ind=21 then job='U';  /* 국제 및 외국기관 */
if job in ('A', 'B', 'T', 'U') then delete;

/* 첫 직장 종사상 지위 */
if g191a388=1 then first_status=g191a021;       /* 현재 직장이 첫 직장 */
else if g191a388=2 then first_status=g191d023;  /* 이직자의 첫 직장 */
else delete;                                   /* 모름·무응답 제외 */

/* 첫 직장이 상용·임시·일용근로자인 경우만 유지 */
if first_status in (1 2 3);


if g191f073=1 then gpa=g191f074/4; * 4점 만점;
if g191f073=2 then gpa=g191f074/4.3; * 4점 만점;
if g191f073=3 then gpa=g191f074/4.5; * 4점 만점;
if g191f073=. then delete;

p_asset=g191p036; * 부모 자산;
p_inc=g191p035; * 부모소득;

wt=g191wt; * 가중치;

keep age gender marry edu job wt c_area college_area high_area major ac g191p001 g191 gpa p_asset p_inc g191f073;
run;

/*proc sort data=d20; by name2; run;*/

/* ============================================================
   0. 주의: d20 생성부에서 반드시 수정할 것
   - keep 문에 c15 추가
   - 제주 출생자 삭제 조건 제거
   - 세종(29)은 충남세종으로 처리
   ============================================================ */

/*
기존 keep 문에 c15 추가:
keep hhid code gender age birth id emp marry sma child edu1 edu2 edu3 own
     htype1 htype2 htype3 c41 c15 birth_area child ctime ctime1 new
     mig1 mig5 nation status1 status2 status3 job job1 job2 job3 job4
     job5 job6 job7 job8 wt korea name2 c_area1 p_sma p_gw p_cc p_hn p_yn p_jj duration;
*/


/* ============================================================
   1. ln_wage 자료 import
   - 제주 포함
   - 세종은 충남에 병합된 16개 시도권
   - name2 순서:
     1 서울
     2 부산
     3 대구
     4 인천
     5 광주
     6 대전
     7 울산
     8 경기
     9 강원
     10 충북
     11 충남세종
     12 전북
     13 전남
     14 경북
     15 경남
     16 제주
   - 2020년 선택모형에는 2019년 임금기회를 사용
   ============================================================ */

/* ============================================================
   1. wage 자료 import
   - 2020년 선택모형에는 2019년 임금 사용
   - ac별 임금패널 사용
   ============================================================ */

proc import out=wage
datafile="&DATA\lnwage_external_wage_iv_panel_resid_16sido.xlsx"
dbms=excel replace;
sheet='actual_lnwage_panel';
run;

data wage2;
    set wage;
    if year = 2019;
    if ac in (1, 2, 3, 4);
run;

/* 산업별 long format 변환: c~s 17개 산업
   ac별 임금패널이므로 ac를 반드시 유지 */
data wage_long;
    set wage2;

    array wvars {*} c d e f g h i j k l m n o p q r s;
    array inames {17} $1 _temporary_
        ('C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S');

    do idx = 1 to dim(wvars);
        job = inames[idx];
        wage_value = wvars[idx];
        output;
    end;

    keep ac name2 job wage_value;
run;

proc sort data=wage_long;
    by ac job;
run;

proc transpose data=wage_long out=wage_wide prefix=wage_;
    by ac job;
    id name2;
    var wage_value;
run;

data wage_wide;
    set wage_wide;

    rename
        wage_1  = wage_a1
        wage_2  = wage_a2
        wage_3  = wage_a3
        wage_4  = wage_a4
        wage_5  = wage_a5
        wage_6  = wage_a6
        wage_7  = wage_a7
        wage_8  = wage_a8
        wage_9  = wage_a9
        wage_10 = wage_a10
        wage_11 = wage_a11
        wage_12 = wage_a12
        wage_13 = wage_a13
        wage_14 = wage_a14
        wage_15 = wage_a15
        wage_16 = wage_a16;

    drop _NAME_;
run;


/* ============================================================
   2. residual 자료 import
   - 2020년 선택모형에는 2019년 residual 사용
   - ac별 first-stage residual 사용
   ============================================================ */

proc import out=resid
datafile="&DATA\lnwage_external_wage_iv_panel_resid_16sido.xlsx"
dbms=excel replace;
sheet='resid_lnwage_panel';
run;

data resid2;
    set resid;
    if year = 2019;
    if ac in (1, 2, 3, 4);
run;

data resid_long;
    set resid2;

    array rvars {*} c d e f g h i j k l m n o p q r s;
    array inames {17} $1 _temporary_
        ('C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S');

    do idx = 1 to dim(rvars);
        job = inames[idx];
        resid_value = rvars[idx];
        output;
    end;

    keep ac name2 job resid_value;
run;

proc sort data=resid_long;
    by ac job;
run;

proc transpose data=resid_long out=resid_wide prefix=resid_;
    by ac job;
    id name2;
    var resid_value;
run;

data resid_wide;
    set resid_wide;

    rename
        resid_1  = resid_a1
        resid_2  = resid_a2
        resid_3  = resid_a3
        resid_4  = resid_a4
        resid_5  = resid_a5
        resid_6  = resid_a6
        resid_7  = resid_a7
        resid_8  = resid_a8
        resid_9  = resid_a9
        resid_10 = resid_a10
        resid_11 = resid_a11
        resid_12 = resid_a12
        resid_13 = resid_a13
        resid_14 = resid_a14
        resid_15 = resid_a15
        resid_16 = resid_a16;

    drop _NAME_;
run;


/* ============================================================
   3. 개인자료와 merge
   - 핵심 수정: ac × job 기준으로 merge
   - 근무지: c41 기준 16개 시도권 재코딩
   - 출생지: c15 기준 16개 시도권 재코딩
   - 세종(29)은 충남세종 11번으로 처리
   ============================================================ */

proc sort data=d20;
    by ac job;
run;

proc sort data=wage_wide;
    by ac job;
run;

proc sort data=resid_wide;
    by ac job;
run;

data job20;
    merge d20(in=a) wage_wide(in=b) resid_wide(in=c);
    by ac job;

    if a;

    /* A, B는 임금패널에서 제외했으므로 개인자료에서도 제외 */
    if job in ('A','B') then delete;

    /* 연령대가 정의되지 않은 관측치 제외 */
    if ac not in (1, 2, 3, 4) then delete;

    /* 근무지 16개 시도권 */
    c_alt = .;
    if c_area = 11 then c_alt = 1;   * 서울;
    if c_area = 21 then c_alt = 2;   * 부산;
    if c_area = 22 then c_alt = 3;   * 대구;
    if c_area = 23 then c_alt = 4;   * 인천;
    if c_area = 24 then c_alt = 5;   * 광주;
    if c_area = 25 then c_alt = 6;   * 대전;
    if c_area = 26 then c_alt = 7;   * 울산;
    if c_area = 31 then c_alt = 8;   * 경기;
    if c_area = 32 then c_alt = 9;   * 강원;
    if c_area = 33 then c_alt = 10;  * 충북;
    if c_area in (34 29) then c_alt = 11; * 충남세종;
    if c_area = 35 then c_alt = 12;  * 전북;
    if c_area = 36 then c_alt = 13;  * 전남;
    if c_area = 37 then c_alt = 14;  * 경북;
    if c_area = 38 then c_alt = 15;  * 경남;
    if c_area = 39 then c_alt = 16;  * 제주;

    if c_alt = . then delete;

    /* 고교 소재지 16개 시도권 */
    high_alt = .;
    if high_area = 11 then high_alt = 1;   * 서울;
    if high_area = 21 then high_alt = 2;   * 부산;
    if high_area = 22 then high_alt = 3;   * 대구;
    if high_area = 23 then high_alt = 4;   * 인천;
    if high_area = 24 then high_alt = 5;   * 광주;
    if high_area = 25 then high_alt = 6;   * 대전;
    if high_area = 26 then high_alt = 7;   * 울산;
    if high_area = 31 then high_alt = 8;   * 경기;
    if high_area = 32 then high_alt = 9;   * 강원;
    if high_area = 33 then high_alt = 10;  * 충북;
    if high_area in (34 29) then high_alt = 11; * 충남세종;
    if high_area = 35 then high_alt = 12;  * 전북;
    if high_area = 36 then high_alt = 13;  * 전남;
    if high_area = 37 then high_alt = 14;  * 경북;
    if high_area = 38 then high_alt = 15;  * 경남;
    if high_area = 39 then high_alt = 16;  * 제주;

	 /* 대학소재지  16개 시도권 */
 	college_alt = .;
    if college_area = 11 then college_alt = 1;   * 서울;
    if college_area = 21 then college_alt = 2;   * 부산;
    if college_area = 22 then college_alt = 3;   * 대구;
    if college_area = 23 then college_alt = 4;   * 인천;
    if college_area = 24 then college_alt = 5;   * 광주;
    if college_area = 25 then college_alt = 6;   * 대전;
    if college_area = 26 then college_alt = 7;   * 울산;
    if college_area = 31 then college_alt = 8;   * 경기;
    if college_area = 32 then college_alt = 9;   * 강원;
    if college_area = 33 then college_alt = 10;  * 충북;
    if college_area in (34 29) then college_alt = 11; * 충남세종;
    if college_area = 35 then college_alt = 12;  * 전북;
    if college_area = 36 then college_alt = 13;  * 전남;
    if college_area = 37 then college_alt = 14;  * 경북;
    if college_area = 38 then college_alt = 15;  * 경남;
    if college_area = 39 then college_alt = 16;  * 제주;

    if high_alt = . then delete;
	if college_alt=. then delete;

    /* ac × job 기준 임금/잔차가 모두 붙지 않은 경우 제외 */
    if nmiss(of wage_a1-wage_a16) > 0 then delete;
    if nmiss(of resid_a1-resid_a16) > 0 then delete;

    /* 20~39세만 유지 */
    if age ge 20 and age le 34;

    nage = age - 25;
    year = 1;
run;


/* ============================================================
   4. 16개 시도권 long-format 선택자료 생성
   - a1~a16 대안 더미
   - a1은 기준대안으로 이후 모형에서 제외
   - wages는 2019년 ac × job × 시도별 level wage / 100
   - res는 2019년 ac × job × 시도별 first-stage residual / 100
   ============================================================ */

data lkj.final20;
    set job20;

    array wage  [16] wage_a1-wage_a16;
    array resid [16] resid_a1-resid_a16;

    array alt [16] a1-a16;

    array alt_age [16]
        a1_age a2_age a3_age a4_age a5_age a6_age a7_age a8_age
        a9_age a10_age a11_age a12_age a13_age a14_age a15_age a16_age;

    array alt_gender [16]
        a1_gender a2_gender a3_gender a4_gender a5_gender a6_gender a7_gender a8_gender
        a9_gender a10_gender a11_gender a12_gender a13_gender a14_gender a15_gender a16_gender;

    array alt_marry [16]
        a1_marry a2_marry a3_marry a4_marry a5_marry a6_marry a7_marry a8_marry
        a9_marry a10_marry a11_marry a12_marry a13_marry a14_marry a15_marry a16_marry;

    array alt_edu [16]
        a1_edu a2_edu a3_edu a4_edu a5_edu a6_edu a7_edu a8_edu
        a9_edu a10_edu a11_edu a12_edu a13_edu a14_edu a15_edu a16_edu;

	array alt_major [16]
        a1_major a2_major a3_major a4_major a5_major a6_major a7_major a8_major
        a9_major a10_major a11_major a12_major a13_major a14_major a15_major a16_major;

	array alt_gpa [16]
        a1_gpa a2_gpa a3_gpa a4_gpa a5_gpa a6_gpa a7_gpa a8_gpa
        a9_gpa a10_gpa a11_gpa a12_gpa a13_gpa a14_gpa a15_gpa a16_gpa;

    subject = _n_;

    do i = 1 to 16;

        do k = 1 to 16;
            alt[k] = (i = k);

            alt_age[k]    = alt[k] * nage;
            alt_gender[k] = alt[k] * gender;
            alt_marry[k]  = alt[k] * marry;
            alt_edu[k]    = alt[k] * edu;
			alt_major[k]    = alt[k] * major;
			alt_gpa[k]    = alt[k] * gpa;
        end;

        decision = (c_alt = i);

        /* actual_lnwage_panel이라는 시트명과 달리 값은 level wage임 */
        wages = wage[i] / 100;

        /* resid_lnwage_panel이라는 시트명과 달리 값은 level-wage residual임 */
        res = resid[i] / 100;

        /* 출생 시도권 일치 */
        high = (high_alt = i);
		college=(college_alt=i);
        output;
    end;

    drop k;

    keep subject i decision year ac
         wages high college res
		a1  a1_age  a1_gender  a1_marry  a1_edu a1_major a1_gpa
        a2  a2_age  a2_gender  a2_marry  a2_edu a2_major a2_gpa
        a3  a3_age  a3_gender  a3_marry  a3_edu a3_major a3_gpa
        a4  a4_age  a4_gender  a4_marry  a4_edu a4_major a4_gpa
        a5  a5_age  a5_gender  a5_marry  a5_edu a5_major a5_gpa
        a6  a6_age  a6_gender  a6_marry  a6_edu a6_major a6_gpa
        a7  a7_age  a7_gender  a7_marry  a7_edu a7_major a7_gpa
        a8  a8_age  a8_gender  a8_marry  a8_edu a8_major a8_gpa
        a9  a9_age  a9_gender  a9_marry  a9_edu a9_major a9_gpa
        a10 a10_age a10_gender a10_marry a10_edu a10_major a10_gpa
        a11 a11_age a11_gender a11_marry a11_edu a11_major a11_gpa
        a12 a12_age a12_gender a12_marry a12_edu a12_major a12_gpa
        a13 a13_age a13_gender a13_marry a13_edu a13_major a13_gpa
        a14 a14_age a14_gender a14_marry a14_edu a14_major a14_gpa
        a15 a15_age a15_gender a15_marry a15_edu a15_major a15_gpa
        a16 a16_age a16_gender a16_marry a16_edu a16_major a16_gpa;
run;

proc mdc data=lkj.final20;

    model decision =
        wages high college res

        a2  a2_age  a2_gender   a2_edu a2_major a2_gpa
        a3  a3_age  a3_gender   a3_edu a3_major a3_gpa
        a4  a4_age  a4_gender   a4_edu a4_major a4_gpa
        a5  a5_age  a5_gender   a5_edu a5_major a5_gpa
        a6  a6_age  a6_gender   a6_edu a6_major a6_gpa
        a7  a7_age  a7_gender   a7_edu a7_major a7_gpa
        a8  a8_age  a8_gender   a8_edu a8_major a8_gpa
        a9  a9_age  a9_gender   a9_edu a9_major a9_gpa
        a10 a10_age a10_gender a10_edu a10_major a10_gpa
        a11 a11_age a11_gender a11_edu a11_major a11_gpa
        a12 a12_age a12_gender a12_edu a12_major a12_gpa
        a13 a13_age a13_gender a13_edu a13_major a13_gpa
        a14 a14_age a14_gender a14_edu a14_major a14_gpa
        a15 a15_age a15_gender a15_edu a15_major a15_gpa
        a16 a16_age a16_gender a16_edu a16_major a16_gpa

        / type=mixedlogit
          nchoice=16 optmethod=tr mixed=(normalparm=wages high college) ;

    id subject;
run;

proc freq data=d20;
table age;
run;
/*ods output close;*/
/**/
/*ods output ParameterEstimates=mdc_params;*/
/**/
/*proc mdc data=final20; */
/*model decision =*/
/*    wages same  res*/
/*    two two_age two_gender two_marry two_edu3*/
/*    three three_age three_gender three_marry three_edu3 */
/*    four four_age four_gender four_marry four_edu3*/
/*    five five_age five_gender five_marry five_edu3 */
/*    / type=mprobit nchoice=5*/
/*	      mixed=(normalparm=wages  same)*/
/*		  optmethod=tr;*/
/*id subject;*/
/*run;*/
/**/
/*ods output close;*/
/**/
/**/
/*data final20_mdc;*/
/*set final20;*/
/*keep subject i decision wages res same*/
/*     two three four five*/
/*     two_age two_gender two_marry two_edu3*/
/*     three_age three_gender three_marry three_edu3*/
/*     four_age four_gender four_marry four_edu3*/
/*     five_age five_gender five_marry five_edu3;*/
/*run;*/
/**/
/*proc export data=final20_mdc*/
/*outfile="&RESULTS\final20.csv"*/
/*dbms=csv replace;*/
/*run;*/
/**/
/*proc export data=mdc_params*/
/*outfile="&RESULTS\mdc_params.csv"*/
/*dbms=csv replace;*/
/*run;*/
/**/
/*proc freq data=d20; where emp=1 and age ge 20 and age le 39 and status1=1 and duration=1;*/
/*table c41;*/
/*run;*/
