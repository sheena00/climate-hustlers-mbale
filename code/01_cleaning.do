clear all
set more off
cd ".."

use "data/newdata.dta", replace

drop istheselectedparticipantpre_num starttime submissiontime_num timetaken_num subcountydivisionmbr villagecell_mbr sd6whatisyourdateofbirth_num sd10whatisyourreligion_num md1wereyoubornandliveinm_num lh1aotherspecify endtime_num othersspecify006_num inwhatlanguagewasthisinte_num dontknowsd12 noresponsesd12 //dropping unecessary colums

rename district_num district
drop if district=="Mbarara" //keeping only Mbale 
keep if participantcategory_num == "Youth Migrant (Climate-Related)"// keeping only climate youth migrants

**************renaming variables  ***************************
rename sd5howoldwereyouatyourla age
rename sd8howmanyyearsofschooling years_schooling
rename sd11whatisyourethnicgroup_num tribe
rename sd9whatisyourrelationships_num marital_status
rename sd12livealone sty_live_alone
rename md2atwhatagedidyouleavey age_at_migration
rename md7wasthismovefromyourori_num migration_type
rename lh1whatistheprimaryactivit_num primary_livelihood
rename lh2areyoupaidincashorin_num livelihood_paymentmode

rename livewithparents sty_parents
rename otherfamilymembers sty_otherfamily
rename spouse_partner sty_partner
rename friends_peers sty_friends
rename employer_workmates sty_workmates_employer

rename sd14atpresentdoyoulivein_num housing_type
encode housing_type, gen(housing_type_num)

rename extremelyhot mig_extremelyhot
rename extremlycold mig_extremlycold
rename floods mig_floods
rename drought mig_drought
rename landslides mig_landslides
rename hailstones mig_hailstones
rename foodinsecurityduetoweahther mig_foodinsecurity
rename reducedagriculturalopportunities mig_reducedagricopp
rename lossoflivelihoods mig_livelihoodsloss
rename reductionincropyields mig_redcropyields
rename reductioninlivestockproductivity mig_redlivestockprod
rename croppestsanddiseasesduetoweather mig_croppestsdiseases
rename livestockpestsduetoweather mig_livestockpestdisease
rename declineinwateravailability mig_declinewateravail
rename highcompetitionforresources mig_highresourcecompetition
rename conflictduetoweatherevents mig_conflict
rename reducedavailabilityofservices mig_reducedserviceavail

foreach var of varlist _all {       //printing empty columns
    quietly count if !missing(`var')
    if r(N) == 0 {
        display "`var' is completely empty"
    }
}

foreach var of varlist mig_* { //coding migration reasons
    gen `var'_num = .
    replace `var'_num = 1 if lower(trim(`var')) == "yes"
    replace `var'_num = 0 if lower(trim(`var')) == "no"
}

*****************gender coding ***********************************
rename sd4recordrespondentsex_num gender 

gen gender_num = 0
replace gender_num = 1 if gender == "Male"
label define genderlab 0 "Female" 1 "Male"
label values gender_num genderlab


****************education coding **********************************
rename sd7whatisthehighestlevelo_num education
gen educ_simple = .

replace educ_simple = 1 if education == "Never attended" 
    
replace educ_simple = 2 if education ==  "Some primary" ///
    | education == "Completed primary"

replace educ_simple = 3 if education == "Some  O'level" ///
    | education == "Completed  O'level" ///
    | education == "Some A'level" ///
    | education == "A  level"

replace educ_simple = 4 if education == "Tertiary"

label define educlab 1 "None" 2 "Primary" 3 "Secondary" 4 "Post-secondary"
label values educ_simple educlab



**********************subregion coding **************************
rename md3whichisyourdistrictofo_num district_origin

replace district_origin= md3aotherspecify_num if md3aotherspecify_num != ""
drop md3aotherspecify_num //adding districts of origins in the other column


gen subregion = ""
replace subregion = "Acholi" if inlist(district_origin, ///
"Agago","Amuru","Gulu","Kitgum","Lamwo","Nwoya","Omoro","Pader")

replace subregion = "Lango" if inlist(district_origin, ///
"Alebtong","Amolatar","Apac","Dokolo","Kole","Lira","Oyam","Otuke","Kwania")

replace subregion = "Karamoja" if inlist(district_origin, ///
"Abim","Amudat","Kabong","Karenga","Kotido","Moroto","Nabilatuk","Napak","Nakapiripirit")

replace subregion = "West Nile" if inlist(district_origin, ///
"Koboko","Maracha","Moyo","Nebbi","Pakwach","Zombo","Terego")

replace subregion = "Teso" if inlist(district_origin, ///
"Amuria","Bukedea","Kaberamaido","Katakwi","Kapelebyong")
replace subregion = "Teso" if inlist(district_origin, ///
"Kumi","Ngora","Serere","Soroti","Kalaki")

replace subregion = "Bugisu" if inlist(district_origin, ///
"Bududa","Bulambuli","Manafwa","Mbale","Namisindwa","Sironko","Budadiri")

replace subregion = "Bukedi" if inlist(district_origin, ///
"Budaka","Bugiri","Busia","Butaleja","Butalejja","Butebo","Kibuku","Pallisa","Tororo")

replace subregion = "Busoga" if inlist(district_origin, ///
"Iganga","Jinja","Kaliro","Kamuli","Luuka","Mayuge","Namayingo","Namutumba")

replace subregion = "Sebei" if inlist(district_origin, ///
"Bukwo","Kapchorwa","Kween")

replace subregion = "Ankole" if inlist(district_origin, ///
"Buhweju","Bushenyi","Ibanda","Isingiro","Kiruhura","Kazo","Mitooma","Ntungamo","Mbarara")

replace subregion = "Kigezi" if inlist(district_origin, ///
"Kabale","Kanungu","Kisoro","Rukungiri","Rukiga","Rubanda")

replace subregion = "Toro" if inlist(district_origin, ///
"Bunyangabu","Kabarole","Kamwenge","Kyegegwa","Kyenjojo","Fort Portal City")

replace subregion = "Bunyoro" if inlist(district_origin, ///
"Buliisa","Hoima","Kagadi","Kakumiro","Kibaale","Kiryandongo","Masindi")

replace subregion = "Rwenzori" if inlist(district_origin, ///
"Bundibugyo","Kasese","Ntoroko")

replace subregion = "Buganda" if inlist(district_origin, ///
"Buikwe","Gomba","Kayunga","Nakaseke","Sembabule","Wakiso","Kyotera")


*********************hustle topology construction**************************************

*individual assets
foreach var in aradio_num atelevision_num anonmobiletelephone_num acomputer_num  arefrigerator_num acassettecddvdplayer_num atable_num  achair_num asofaset_num abed_num acupboard_num aclock_num awatch_num amobilephone_num abicycle_num amotorcycleormotorscooter_num ananimaldrawncart_num  acarortruck_num aboatwithamotor_num aboatwithoutamotor_num  {
    replace `var' = lower(`var')
    replace `var' = "1" if `var' == "yes"
    replace `var' = "0" if `var' == "no"
    destring `var', replace
	replace `var' = 0 if missing(`var')
}

gen ind_asset_count = aradio_num + atelevision_num + anonmobiletelephone_num + acomputer_num + arefrigerator_num + acassettecddvdplayer_num +  atable_num + achair_num + asofaset_num + abed_num + acupboard_num + aclock_num + awatch_num +amobilephone_num + abicycle_num + amotorcycleormotorscooter_num + ananimaldrawncart_num + acarortruck_num + aboatwithamotor_num + aboatwithoutamotor_num

gen ind_asset_level = .
replace ind_asset_level = 0 if ind_asset_count == 0
replace ind_asset_level = 1 if ind_asset_count >=1 & ind_asset_count <=2
replace ind_asset_level = 2 if ind_asset_count >=3

*household assets

foreach var in radio  television  nonmobiletelephone computer refrigerator cassetecd table chair sofaset bed cupboard clock watch mobilephone bicycle motorcycle animaldrawn carortruck boatwithmotor boatwithoutmotor {
    replace `var' = lower(`var')
    replace `var' = "1" if `var' == "yes"
    replace `var' = "0" if `var' == "no"
    destring `var', replace
	replace `var' = 0 if missing(`var')
}


gen hh_asset_count = radio + television + nonmobiletelephone + computer + refrigerator + cassetecd + table + chair + sofaset + bed + cupboard + clock + watch + mobilephone + bicycle + motorcycle + animaldrawn + carortruck + boatwithmotor + boatwithoutmotor

gen hh_asset_level = .
replace hh_asset_level = 0 if hh_asset_count == 0
replace hh_asset_level = 1 if hh_asset_count >=1 & hh_asset_count <=2
replace hh_asset_level = 2 if hh_asset_count >=3

*savings
gen savings_member = 0
replace savings_member = 1 if hc22doyoubelongtoanysavin_num == "Yes"

*income activities
gen prim_activity = 0
replace prim_activity = 1 if primary_livelihood == "Domestic work" | primary_livelihood == "Formal salaried employment" |primary_livelihood == "Small  (petty)  business" |primary_livelihood == "Casual labour" |primary_livelihood == "Mason or Artisan" |primary_livelihood == "Raising livestock" |primary_livelihood == "Medium or large business" |primary_livelihood == "Subsistence farming" |primary_livelihood == "Sex work"  |primary_livelihood == "Driver/ Rider (Boda boda, Taxi etc)" 

gen first_activity = 0
replace first_activity = 1 if ///
lh14haveyoustoppeddoingthe_num == "No" & ///
inlist(lh13beforeyoustartedthispr_num, ///
    "Domestic work", ///
    "Formal salaried employment", ///
    "Small  (petty)  business", ///
    "Casual labour", ///
    "Mason or Artisan", ///
    "Raising livestock", ///
    "Entertainment/ Sports") 

replace first_activity = 1 if ///
lh14haveyoustoppeddoingthe_num == "No" & ///
inlist(lh13beforeyoustartedthispr_num, ///
    "Waiter/Waitress", ///
	    "Medium or large business", ///
    "Subsistence farming", ///
    "Driver/ Rider (Boda boda, Taxi etc)", ///
    "Sex work")

gen other_activity = 0
replace other_activity = 1 if lh16whatelsedoyoudotosup_num == "Domestic work" |lh16whatelsedoyoudotosup_num == "formal salaried employment" |lh16whatelsedoyoudotosup_num == "Small  (petty)  business" |lh16whatelsedoyoudotosup_num == "Casual labour" |lh16whatelsedoyoudotosup_num == "Casual labour Domestic work" |lh16whatelsedoyoudotosup_num == "Casual labour Small  (petty)  business" |lh16whatelsedoyoudotosup_num == "Others  specify" |lh16whatelsedoyoudotosup_num == "Sex work Unemployed " |lh16whatelsedoyoudotosup_num == "Subsistence farming" 


gen number_income_activities = prim_activity + first_activity + other_activity

gen multiple_jobs = 0
replace multiple_jobs = 1 if number_income_activities > 1

gen informal_primary = 1
replace informal_primary = 0 if ///
primary_livelihood == "Formal salaried employment" | ///
primary_livelihood == "Unemployed/Nothing" | ///
primary_livelihood == "Student"
	
gen formal_primary = 0
replace formal_primary = 1 if primary_livelihood == "Formal salaried employment"

*hustle topography

gen hustle_type = .

replace hustle_type = 5 if primary_livelihood == "Unemployed/Nothing" | primary_livelihood == "Student"

replace hustle_type = 4 if formal_primary == 1 & hustle_type == .

replace hustle_type = 3 if informal_primary==1 ///
 & ind_asset_level >=2 ///
 & savings_member==1 ///
 & hustle_type == .
 
 replace hustle_type = 2 if informal_primary==1 ///
 & multiple_jobs==1 ///
 & hustle_type == .
 
 replace hustle_type = 1 if informal_primary==1 ///
 & multiple_jobs==0 ///
 & ind_asset_level<=1 ///
 & savings_member==0 ///
 & hustle_type == .

 
label define hust 1 "Survivalist" ///
                  2 "Diversified coping" ///
                  3 "Asset-accumulating" ///
                  4 "Formal wage" ///
                  5 "Unemployed"
label values hustle_type hust


tab hustle_type
tab hustle_type gender_num, col
tab hustle_type educ_simple, col //educ_simple

***********************Unemployment************************
gen unemployed_bin = (primary_livelihood == "Unemployed/Nothing")
	 
gen living_arrangement = .
replace living_arrangement = 1 if lower(trim(sty_live_alone)) == "yes"
replace living_arrangement = 2 if lower(trim(sty_partner)) == "yes"
replace living_arrangement = 3 if lower(trim(sty_parents)) == "yes"
replace living_arrangement = 4 if lower(trim(sty_otherfamily)) == "yes"
replace living_arrangement = 5 if lower(trim(sty_friends)) == "yes"
replace living_arrangement = 6 if lower(trim(sty_workmates_employer)) == "yes"

label define living_arr 1 "Alone" 2 "Partner" 3 "Parents" 4 "Other family" 5 "Friends" 6 "Employer"
label values living_arrangement living_arr

*****************************agency coding*******************
gen skills_training = 0
gen bank_account = 0
replace bank_account = 1 if hc21adoyouhaveabankaccoun_num == "Yes"
replace skills_training = 1 if lh4didyouhavetolearnnews_num =="Yes"
gen agency_score = multiple_jobs + savings_member + skills_training + bank_account
				   
gen high_agency = 0
replace high_agency = 1 if agency_score >= 2

*******************************capability*********************************

*life better
rename mh28mylifeisbetternowthan_num life_better

gen life_better_num  = .

replace life_better_num = 5 if life_better == "Strongly Agree"
replace life_better_num  = 4 if life_better == "Agree"
replace life_better_num  = 3 if life_better == "Neither agree nor disagree"
replace life_better_num  = 2 if life_better == "Disagree"
replace life_better_num  = 1 if life_better == "Strongly disagree"
replace life_better_num = . if life_better == "Don't Know"

*basic needs
rename mh24iamconfidentthatihave_num  cover_basic_needs

gen cover_basic_needs_num = .

replace cover_basic_needs_num = 5 if cover_basic_needs == "Strongly Agree"
replace cover_basic_needs_num = 4 if cover_basic_needs == "Agree"
replace cover_basic_needs_num = 3 if cover_basic_needs == "Neither agree nor disagree"
replace cover_basic_needs_num = 2 if cover_basic_needs == "Disagree"
replace cover_basic_needs_num = 1 if cover_basic_needs == "Strongly disagree"


label define likert5 1 "Strongly disagree" 2 "Disagree" 3 "Neither" 4 "Agree" 5 "Strongly agree"
label values life_better_num likert5
label values cover_basic_needs_num likert5

gen capability_simple = (cover_basic_needs_num + life_better_num)/2 //capability index
sum capability_simple

* mental health wellbeing
rename dp1overthelast2weekshow_num wlbng_littleintrest
rename dp2overthelast2weekshow_num wlbng_depressed
rename dp3overthelast2weekshow_num wlbng_troublesleep
rename  dp4overthelast2weekshow_num wlbng_tired
rename dp5overthelast2weekshow_num wlbng_appetite
rename dp6overthelast2weekshowo_num wlbng_failure
rename dp7overthelast2weekshow_num wlbng_noconcentrate
rename dp8overthelast2weekshow_num wlbng_slow
rename dp9overthelast2weekshow_num wlbng_hurt

foreach var in wlbng_littleintrest wlbng_depressed wlbng_troublesleep ///
               wlbng_tired wlbng_appetite wlbng_failure ///
               wlbng_noconcentrate wlbng_slow wlbng_hurt {

    encode `var', gen(`var'_num)
}

foreach var in wlbng_littleintrest_num wlbng_depressed_num ///
               wlbng_troublesleep_num wlbng_tired_num ///
               wlbng_appetite_num wlbng_failure_num ///
               wlbng_noconcentrate_num wlbng_slow_num ///
               wlbng_hurt_num {

    recode `var' (3=0) (4=1) (1=2) (2=3)
}

foreach var in wlbng_littleintrest wlbng_depressed wlbng_troublesleep ///
               wlbng_tired wlbng_appetite wlbng_failure ///
               wlbng_noconcentrate wlbng_slow wlbng_hurt {

    drop `var'
    rename `var'_num `var'
}

egen phq9_total = rowtotal(wlbng_littleintrest wlbng_depressed ///
                           wlbng_troublesleep wlbng_tired ///
                           wlbng_appetite wlbng_failure ///
                           wlbng_noconcentrate wlbng_slow ///
                           wlbng_hurt)
						   
						   
save "data\cleandata.dta", replace

