//Is there any relationship between evictions and rates of homelessness in the USA?

clear

*********************************************************************
******************* US HUD PIT Homelessness data ********************
*********************************************************************

* PIT excel initially formatted with one year per sheet and one state per row. For each sheet in PIT excel, create an individual stata dataset
forvalues x = 2008(1)2019 {
import excel "2007-2022-PIT-Counts-by-State.xlsx", sheet (`x') firstrow clear
gen year = `x'
save `x'.dta, replace
clear
}

* append the datasets we just created into one dataset named pit.dta
use 2008.dta
forvalues x = 2009(1)2019 {
append using `x'.dta
save pit.dta, replace
}

clear
use pit.dta

* drop observations of nationwide totals, empty rows, and variables  which don't correspond to overall number of homeless people and overall count of chronically homeless people
drop if strpos(State, "Total")>0

rename (State OverallHomeless OverallHomelessIndividuals OverallHomelessPeopleinFamil OverallChronicallyHomelessInd OverallChronicallyHomeless OverallChronicallyHomelessPeo) (state overall indv fam chronic_indv chronic chronic_infam)

keep state overall indv fam year chronic_indv chronic chronic_infam
destring, replace
order year, after(state)
drop if missing(overall)

* Install statastates module to add state abbreviations and fips to dataset. Having common state IDs allows us to easily merge datasets
ssc install statastates
statastates, abbreviation(state) nogenerate
drop if missing(state_fips)

* notice that prior to 2012, chronic and chronic_infam have no observations; all overall chronic data is recorded in chronic_indv. from 2012 on, chronic is the sum of chronic_indv and chronic_infam. since chronic_indv seems to be the sole overall measure of chronic homelessness prior to 2012 i'll fill the blanks under chronic with values from chronic_indv. 
replace chronic = chronic_indv if missing(chronic)
drop chronic_indv chronic_infam

save pit.dta, replace

// Use US Census Bureau's yearly population estimates to obtain homeless per capita.
* 2000-2010: https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2000-2010-state.html
* 2010-2020: https://www.census.gov/programs-surveys/popest/technical-documentation/research/evaluation-estimates/2020-evaluation-estimates/2010s-state-total.html
* I combined & reformatted the Census Bureau's 2000-2010 and 2010-2020 population estimates in Excel ("popest_08-19.xlsx") to reduce hassle

clear
import delimited "popests.csv"
drop v1

* reshape to panel dataset format
reshape long y, i(state) j(year)
rename (y state) (pop state_name)
replace state_name = upper(state_name)
save pop.dta, replace

merge 1:1 state_name year using pit.dta, nogenerate

gen homelesscap = overall/pop * 1000
gen chroniccap = chronic/pop * 1000
label variable homelesscap "number of homeless persons per 1000"
label variable chroniccap "number of chronically homeless persons per 1000"

save pit.dta, replace


*********************************************************************
************** Princeton University Eviction Lab data ***************
*********************************************************************

//Princeton University's Eviction Lab (https://data-downloads.evictionlab.org/#data-for-analysis/)

clear
import delimited "county_court-issued_2000_2018.csv"
rename state state_name

gen filerate = filings_observed/renting_hh * 1000

* Dataset provides observations by county by year. Collapse dataset to get median eviction filing rate among the counties of each state and year. County-level analysis is likely possible but too much right now
collapse (median) renting_hh filerate, by(year state_name)
label variable filerate "median eviction filings per 1000 renting households in fileyear"
label variable renting_hh "median proportion of renting_hh"

* in general, the effect of an eviction filing may take some time to manifest, so I'm staggering between this dataset and pit.dta, associating 2007 eviction filing numbers with 2008 homelessness numbers and so on
gen fileyear = year - 1
drop if fileyear < 2007

* Have statastates match state fips and abbreviations
statastates, name(state_name) nogenerate
save evict.dta


*********************************************************************
*********************** MIT Election Lab data ***********************
*********************************************************************

clear
import delimited "1976-2020-senate.csv", parselocale(en_US)

keep year state state_po state_fips candidatevotes totalvotes party_simplified
rename state_po state_abbrev
sort state_abbrev year candidatevotes

* filter out nonwinning candidates
by state_abbrev year: egen maxvotes = max(candidatevotes)
keep if candidatevotes == maxvotes

* count number of wins for each party then set binary variables red = 1 or blue = 1 if respective party won >60% of the state's elections. swing states red = 0 blue = 0
by state_abbrev: egen redcount = total(party_simplified =="REPUBLICAN")
by state_abbrev: egen bluecount = total(party_simplified =="DEMOCRAT")
by state_abbrev: egen stateobs = count(state)
///////////gen cutoff = stateobs * 0.6 // will consider a state red or blue if party won over 60% of elections. idk just made it up

gen red = redcount > stateobs * 0.6
gen blue = bluecount > stateobs * 0.6

* collapse since we are simply categorizing states based on overall voting
collapse red blue, by(state_abbrev)
save stateparties.dta


*********************************************************************
******** US Census Bureau Historical Population Density data ********
*********************************************************************

// account for relaationship between more urban vs more rural settings and homelessness

clear
import excel "population-density-data-table.xlsx", sheet("Population Density") cellrange(A5:AN56) firstrow

rename (A DensityRank2010Census) (state_name densityrank)
keep state_name densityrank

* states ranked 1-26 I will consider "dense" or more urban, and the rest more rural (or more accurately less urban). A flawed measure but im me
gen dense = densityrank <= 26
statastates, name(state_name) nogenerate

save popdensity.dta


*********************************************************************
*************************** FINAL MERGE *****************************
*********************************************************************

use pit.dta, clear

// merge with evict.dta
merge 1:1 state_name year using evict.dta, nogenerate

drop if missing(filerate)

keep state_fips state_name state_abbrev year fileyear filerate homelesscap chroniccap
order state_fips state_name state_abbrev year fileyear filerate homelesscap chroniccap

// merge with stateparties.dta
merge m:1 state_abbrev using stateparties.dta
// for some reason there's no eviction data for Idaho or West Virginia, and DC has no representation in Senate so those obs did not get matched during the merge. Dropping said obs
drop if _merge != 3
drop _merge

// merge with popdensity.dta
merge m:1 state_abbrev using popdensity.dta
drop _merge
drop if missing(red)

sort state_fips year
save homelesspanel.dta