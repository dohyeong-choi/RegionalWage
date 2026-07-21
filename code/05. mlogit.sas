/* 실행 전에 code\00.config.sas 를 먼저 submit 하세요. (PROJ / DATA / RESULTS / KEUS 매크로 변수) */
libname lkj "&DATA";
options compress=binary;

data lkj.final;
    set lkj.final15(in=in15) lkj.final20(in=in20);

    /* pooled year dummy: 2015=0, 2020=1 */
    y2020 = in20;

    /* pooled에서 subject 중복 방지 */
    subject_pool = subject + 10000000*y2020;

    /* year interactions for alternative-varying variables */
    y_wages = y2020*wages;
    y_high  = y2020*high;
	y_college =y2020*college;
    y_res   = y2020*res;

    /* province × 2020 alternative-specific constants
       base alternative a1 is omitted */
    a2_y2020  = y2020*a2;
    a3_y2020  = y2020*a3;
    a4_y2020  = y2020*a4;
    a5_y2020  = y2020*a5;
    a6_y2020  = y2020*a6;
    a7_y2020  = y2020*a7;
    a8_y2020  = y2020*a8;
    a9_y2020  = y2020*a9;
    a10_y2020 = y2020*a10;
    a11_y2020 = y2020*a11;
    a12_y2020 = y2020*a12;
    a13_y2020 = y2020*a13;
    a14_y2020 = y2020*a14;
    a15_y2020 = y2020*a15;
    a16_y2020 = y2020*a16;
run;


*2015;
proc mdc data=d15;

    model decision =
        wages same res          
	
        a2   a2_age  a2_gender  a2_marry  a2_edu3
        a3   a3_age  a3_gender  a3_marry  a3_edu3
        a4   a4_age  a4_gender  a4_marry  a4_edu3
        a5   a5_age  a5_gender  a5_marry  a5_edu3
        a6   a6_age  a6_gender  a6_marry  a6_edu3
        a7   a7_age  a7_gender  a7_marry  a7_edu3
        a8   a8_age  a8_gender  a8_marry  a8_edu3
        a9   a9_age  a9_gender  a9_marry  a9_edu3
        a10 a10_age a10_gender a10_marry a10_edu3
        a11 a11_age a11_gender a11_marry a11_edu3
        a12 a12_age a12_gender a12_marry a12_edu3
        a13 a13_age a13_gender a13_marry a13_edu3
        a14 a14_age a14_gender a14_marry a14_edu3
        a15 a15_age a15_gender a15_marry a15_edu3
        a16 a16_age a16_gender a16_marry a16_edu3

        / type=clogit
          nchoice=16 optmethod=tr;
    id subject;
run;

*2020;
proc mdc data=d20;

    model decision =
        wages same res          
	
        a2   a2_age  a2_gender  a2_marry  a2_edu3
        a3   a3_age  a3_gender  a3_marry  a3_edu3
        a4   a4_age  a4_gender  a4_marry  a4_edu3
        a5   a5_age  a5_gender  a5_marry  a5_edu3
        a6   a6_age  a6_gender  a6_marry  a6_edu3
        a7   a7_age  a7_gender  a7_marry  a7_edu3
        a8   a8_age  a8_gender  a8_marry  a8_edu3
        a9   a9_age  a9_gender  a9_marry  a9_edu3
        a10 a10_age a10_gender a10_marry a10_edu3
        a11 a11_age a11_gender a11_marry a11_edu3
        a12 a12_age a12_gender a12_marry a12_edu3
        a13 a13_age a13_gender a13_marry a13_edu3
        a14 a14_age a14_gender a14_marry a14_edu3
        a15 a15_age a15_gender a15_marry a15_edu3
        a16 a16_age a16_gender a16_marry a16_edu3

        / type=clogit
          nchoice=16 optmethod=tr;
    id subject;
run;

ods output ParameterEstimates=mdc_params;

proc mdc data=final;
    where duration=1;

    model decision =
        wages same res
        y_wages y_same y_res

        a2  a2_y2020  a2_age  a2_gender  a2_marry  a2_edu3
        a3  a3_y2020  a3_age  a3_gender  a3_marry  a3_edu3
        a4  a4_y2020  a4_age  a4_gender  a4_marry  a4_edu3
        a5  a5_y2020  a5_age  a5_gender  a5_marry  a5_edu3
        a6  a6_y2020  a6_age  a6_gender  a6_marry  a6_edu3
        a7  a7_y2020  a7_age  a7_gender  a7_marry  a7_edu3
        a8  a8_y2020  a8_age  a8_gender  a8_marry  a8_edu3
        a9  a9_y2020  a9_age  a9_gender  a9_marry  a9_edu3
        a10 a10_y2020 a10_age a10_gender a10_marry a10_edu3
        a11 a11_y2020 a11_age a11_gender a11_marry a11_edu3
        a12 a12_y2020 a12_age a12_gender a12_marry a12_edu3
        a13 a13_y2020 a13_age a13_gender a13_marry a13_edu3
        a14 a14_y2020 a14_age a14_gender a14_marry a14_edu3
        a15 a15_y2020 a15_age a15_gender a15_marry a15_edu3
        a16 a16_y2020 a16_age a16_gender a16_marry a16_edu3

        / type=mprobit
          nchoice=16 optmethod=tr;
/*          mixed=(normalparm=wages same)*/
	 id subject_pool;
run;


ods output close;

ods output ParameterEstimates=mdc_params;

proc export data=lkj.final outfile="&DATA\pooled.dta" dbms=dta replace;
run;
