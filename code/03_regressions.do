clear all
set more off
cd ".."

use "data/cleandata.dta", replace
**************logit unemployed***************
logit unemployed_bin i.gender_num age educ_simple i.living_arrangement, or 

*reg table
label variable gender_num "Male (ref: Female)"
label variable age "Age"
label variable educ_simple "Education"
label variable living_arrangement "Living arrangement"

esttab model1 using table2.rtf, ///
    eform ci ///
    label ///
    nobaselevels ///
    noomitted ///
    compress ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    stats(N chi2 r2_p, ///
          labels("Observations" "LR chi2" "Pseudo R2")) ///
    title("Logistic Regression Predicting Unemployment") ///
    replace
**************mlogit hustle_type*********************************
mlogit hustle_type i.gender_num age educ_simple hh_asset_level, rrr

graph hbar (percent), over(gender_num) over(hustle_type) ///
    asyvars ///
    bar(1, color(orange)) bar(2, color(blue)) ///
    blabel(bar, format(%3.1f) position(outside)) ///
    legend(label(1 "Female") label(2 "Male")) ///
    ytitle("Percent") ///
	
**************************logit agency*************************
logit high_agency i.gender_num age i.educ_simple i.housing_type_num

* Cross-tab: Collective strategy by high agency
tabulate savings_member high_agency, row column chi2

* Cross-tab: Collective strategy by capability
tabulate savings_member capability_simple, row column chi2


**************************regress capability************************
reg capability_simple i.hustle_type

reg capability_simple i.hustle_type age educ_simple multiple_jobs

reg capability_simple high_agency

***********regress mental health***************************

reg phq9_total high_agency
reg phq9_total capability_simple
