/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
libname lkj "&KEUS";

data lkj.wage_panel;
set wage_wide08 wage_wide09 wage_wide10 wage_wide11 wage_wide12 wage_wide13 wage_wide14 wage_wide15 wage_wide16 wage_wide17 wage_wide18 wage_wide19 wage_wide20;
proc sort; by year area1; 
run;

data lkj.employ_panel;
set employ_wide08 employ_wide09 employ_wide10 employ_wide11 employ_wide12 employ_wide13 employ_wide14 employ_wide15 employ_wide16 employ_wide17 employ_wide18 employ_wide19 employ_wide20;
proc sort; by year area1; 
run;
