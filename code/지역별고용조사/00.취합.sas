libname lkj 'D:\이경재\학술대회 및 논문공모전\2027 Journal of Regional Science\분석\지역별 고용조사';

data lkj.wage_panel;
set wage_wide08 wage_wide09 wage_wide10 wage_wide11 wage_wide12 wage_wide13 wage_wide14 wage_wide15 wage_wide16 wage_wide17 wage_wide18 wage_wide19 wage_wide20;
proc sort; by year area1; 
run;

data lkj.employ_panel;
set employ_wide08 employ_wide09 employ_wide10 employ_wide11 employ_wide12 employ_wide13 employ_wide14 employ_wide15 employ_wide16 employ_wide17 employ_wide18 employ_wide19 employ_wide20;
proc sort; by year area1; 
run;
