# Eviction Filing Rates & Homelessness

Using data from the US Department of Housing and Urban Development, the Princeton University Eviction Lab, the US Census Bureau and the MIT Elections Lab, I create a panel dataset observing rate of eviction filings and rate of homelessness by state by year, plus political leaning and population density ranking by state. I explore the data and create a couple of regression models to assess whether more eviction filings is indicative of more homelessness in a state. 

## Data Sources ##
1. Gromis, Ashley, Ian Fellows, James R. Hendrickson, Lavar Edmonds, Lillian Leung, Adam Porton, and Matthew Desmond. Estimating Eviction Prevalence across the United States. Princeton University Eviction Lab. https://data-downloads.evictionlab.org/#data-for-analysis/. Deposited May 13, 2022.
2. MIT Election Data and Science Lab, 2017, "U.S. Senate statewide 1976–2020", https://doi.org/10.7910/DVN/PEJ5QU, Harvard Dataverse, V7, UNF:6:NFZ83YH7C/fCm6x0stmMwA== [fileUNF]
3. United States Census Bureau. 2016. "Intercensal Estimates of the Resident Population for the United States, Regions, States, and Puerto Rico: April 1, 2000 to July 1, 2010". Washington, D.C.: US Census Bureau. [https://www2.census.gov/programs-surveys/popest/tables/2000-2010/intercensal/state/]
4. United States Census Bureau. 2021. "Annual Estimates of the Resident Population for the United States, Regions, States, the District of Columbia, and Puerto Rico: April 1, 2010 to July 1, 2019; April 1, 2020; and July 1, 2020 (NST-EST2020)". Washington, D.C.: US Census Bureau. [https://www2.census.gov/programs-surveys/popest/tables/2010-2020/state/totals/]
5. United States Department of Housing and Urban Development. 2023. "2007 - 2023 PIT Estimates by State". Washington, D.C.: HUD. [https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/]

## Directory ##
`data/`: Datasets directly downloaded from above sources
`stata-files/`: 
- `datacleaning_FINAL.do`: Stata do-file for creating panel dataset
`analysis-in-R/`: 
- `panel-data.csv`: 
`results/`: tables n shit
`finalreport.rmd`
`finalreport.pdf`
`requirements.txt`: software info ig


