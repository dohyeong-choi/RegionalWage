/* =====================================================================
   RegionalWage - 프로젝트 경로 설정

   SAS 세션을 시작할 때 이 파일을 한 번 실행(submit)한 뒤에
   나머지 프로그램(00.취합 / 03 / 04 / 05 ...)을 실행하세요.

     PROJ    : 저장소 루트 (links.yaml이 있는 폴더)
     DATA    : PROJ\data      <- setup_env.py가 만든 구글드라이브 정션
     RESULTS : PROJ\results
     IMAGES  : PROJ\images
     KEUS    : DATA\지역별고용조사
   ===================================================================== */

%global PROJ DATA RESULTS IMAGES KEUS;

/* ---------------------------------------------------------------------
   1. 자동 인식
      SAS 9.4 DMS / Enterprise Guide / SAS Studio는 실행 중인 프로그램의
      전체 경로를 환경변수 SAS_EXECFILEPATH에 넣어 준다.
      이 파일은 <저장소>\code\ 아래에 있으므로 두 단계 위가 저장소 루트다.
   --------------------------------------------------------------------- */
%macro rw_autoroot;
    %local f dir;

    %if %sysfunc(envlen(SAS_EXECFILEPATH)) > 0 %then %do;
        %let f    = %sysget(SAS_EXECFILEPATH);
        %let dir  = %substr(&f,   1, %length(&f)   - %length(%scan(&f,   -1, \)) - 1);
        %let PROJ = %substr(&dir, 1, %length(&dir) - %length(%scan(&dir, -1, \)) - 1);
    %end;
%mend rw_autoroot;

%rw_autoroot;

/* ---------------------------------------------------------------------
   2. 수동 지정
      자동 인식이 안 되는 환경이면 아래 한 줄만 각자 컴퓨터에 맞게 고친다.
      (이 저장소에서 절대경로가 남아 있는 곳은 여기 한 곳뿐이다.)
   --------------------------------------------------------------------- */
%macro rw_defaultroot;
    %if %superq(PROJ) = %then %do;
        %let PROJ = C:\Users\Choi\Documents\local_repos\RegionalWage;
    %end;
%mend rw_defaultroot;

%rw_defaultroot;

%let DATA    = &PROJ\data;
%let RESULTS = &PROJ\results;
%let IMAGES  = &PROJ\images;
%let KEUS    = &DATA\지역별고용조사;

%put NOTE: PROJ    = &PROJ;
%put NOTE: DATA    = &DATA;
%put NOTE: RESULTS = &RESULTS;
%put NOTE: IMAGES  = &IMAGES;
%put NOTE: KEUS    = &KEUS;

%macro rw_checkroot;
    %if %sysfunc(fileexist(&PROJ\links.yaml)) = 0 %then %do;
        %put WARNING: &PROJ 에 links.yaml이 없습니다. PROJ 경로를 확인하세요.;
    %end;
    %if %sysfunc(fileexist(&DATA)) = 0 %then %do;
        %put WARNING: &DATA 폴더가 없습니다. setup_env.py를 먼저 실행하세요.;
    %end;
%mend rw_checkroot;

%rw_checkroot;