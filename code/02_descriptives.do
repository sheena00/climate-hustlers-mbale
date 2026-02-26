clear all
set more off
cd ".."

use "data/cleandata.dta", replace

***** subregion by gender ***************************************************
graph bar (count), over(subregion, sort(1) descending label(angle(45))) ///
    over(gender) ///
    bar(1, color(blue)) bar(2, color(orange)) ///
    legend(label(1 "Male") label(2 "Female")) ///
    ytitle("Number of migrants") ///
    title("Sub-Region of Origin by Gender")

*****age at migration********************************************************
sum age_at_migration
ttest age_at_migration, by(gender)


*******reason for migration*************************************************

drop mig_extremelyhot mig_extremlycold mig_floods mig_drought mig_landslides mig_hailstones mig_foodinsecurity mig_reducedagricopp mig_livelihoodsloss mig_redcropyields mig_redlivestockprod mig_croppestsdiseases mig_livestockpestdisease mig_declinewateravail mig_highresourcecompetition mig_conflict mig_reducedserviceavail //dropping old migration columns

reshape long mig_, i(index) j(reason) string //creating long dataset since it was a multiselect variable
keep if mig_ == 1
replace reason = subinstr(reason, "_num", "", .)
tab reason
tab reason gender, col chi2


gen collapsed_reason = "" //collapsing into major reasons
replace collapsed_reason = "Slow-onset livelihood decline" if ///
inlist(reason, ///
"foodinsecurity", ///
"reducedagricopp", ///
"redcropyields", ///
"redlivestockprod", ///
"reducedserviceavail", ///
"livelihoodsloss", ///
"declinewateravail")

replace collapsed_reason = "Sudden extreme events" if ///
inlist(reason, ///
"floods", ///
"drought", ///
"landslides", ///
"hailstones", ///
"extremelyhot", ///
"extremlycold")

replace collapsed_reason = "Resource conflict/competition" if ///
inlist(reason, ///
"conflict", ///
"highresourcecompetition")

replace collapsed_reason = "Livestock/crop disease" if ///
inlist(reason, ///
"croppestsdiseases", ///
"livestockpestdisease")

tab reason if collapsed_reason == "" // check if all columns are accounted for 
encode collapsed_reason, gen(collapsed_reason_num)
tab collapsed_reason gender, col chi2

******housing type and number of people in house(crowding)************************************

tab housing_type gender, col chi2

rename sd13howmanypeopleareyouin people_in_house
ttest people_in_house, by(gender)


*******living with*****************

foreach var of varlist sty_* {
    gen `var'_num = .
    replace `var'_num = 1 if lower(trim(`var')) == "yes"
    replace `var'_num = 0 if lower(trim(`var')) == "no"
}

drop sty_live_alone sty_parents sty_otherfamily sty_partner sty_friends sty_workmates_employer //dropping old columns

reshape long sty_, i(index) j(living_with) string
keep if sty_ == 1
replace living_with = subinstr(living_with, "_num", "", .)
tab living_with

gen live_alone_bin = (living_with == "live_alone")
gen live_partner_bin = (living_with == "partner")
gen live_parents_bin = (living_with == "parents")
gen live_otherfamily_bin = (living_with == "otherfamily")
gen live_friends_bin = (living_with == "friends")

tab live_alone_bin gender, chi2
tab live_partner_bin gender, chi2
tab live_parents_bin gender, chi2
tab live_otherfamily_bin gender, chi2
tab live_friends_bin gender, chi2


************time before primary livelihood***************
gen time_value = .

destring lh3adaysspecify , replace
replace time_value = lh3adaysspecify if lh3adaysspecify != .
replace time_value = lh3bweeksspecify if lh3bweeksspecify != .
replace time_value = lh3cmonthsspecify if lh3cmonthsspecify != .
replace time_value = lh3dyearsspecify if lh3dyearsspecify != .

gen time_months = .
replace time_months = time_value if lh3howlongdidittakeyouto_num == "Months"
replace time_months = time_value/30 if lh3howlongdidittakeyouto_num == "Days"
replace time_months = time_value*12 if lh3howlongdidittakeyouto_num == "Years"

winsor2 time_months, cuts(5 95) suffix(_win)

ttest time_months_win, by(gender)

*********primary livelihood***************************************************************
tab primary_livelihood gender, col chi2

tab livelihood_paymentmode gender, chi2

rename lh8isyourprimaryactivityso_num work_alone
tab work_alone gender, chi2

*************************hours worked last week, capital***************************
rename lh11lastweekonaveragehow hours_last_week // for primary_livelihood
winsor2 hours_last_week, cuts(5 95) suffix(_win)
ttest hours_last_week_win, by(gender)

rename lh6didyouhavetoacquirecap_num primaryliv_capital//if primary livelihood required capital
tab primaryliv_capital gender, chi2

rename lh7wherehowdidyougetthis_num sourceof_prilivecapital // source of capital
tab sourceof_prilivecapital gender, col chi2




