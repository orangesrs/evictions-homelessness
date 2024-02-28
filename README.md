# Eviction Filing Rates & Homelessness

Using data from the US Department of Housing and Urban Development, the Princeton University Eviction Lab, the US Census Bureau and the MIT Elections Lab, I create a panel dataset observing rate of eviction filings and rate of homelessness by state by year, plus political leaning and population density ranking by state. I explore the data and create a couple of regression models to assess whether a state's rate of eviction filings can indicate higher levels of homelessness.  

## Data Sources ##
1. Gromis, Ashley, Ian Fellows, James R. Hendrickson, Lavar Edmonds, Lillian Leung, Adam Porton, and Matthew Desmond. Estimating Eviction Prevalence across the United States. Princeton University Eviction Lab. https://data-downloads.evictionlab.org/#data-for-analysis/. Deposited May 13, 2022.
2. MIT Election Data and Science Lab, 2017, "U.S. Senate statewide 1976–2020", https://doi.org/10.7910/DVN/PEJ5QU, Harvard Dataverse, V7, UNF:6:NFZ83YH7C/fCm6x0stmMwA== [fileUNF]
3. United States Census Bureau. 2016. "Intercensal Estimates of the Resident Population for the United States, Regions, States, and Puerto Rico: April 1, 2000 to July 1, 2010". Washington, D.C.: US Census Bureau. [URL](https://www2.census.gov/programs-surveys/popest/tables/2000-2010/intercensal/state/)
4. United States Census Bureau. 2021. "Annual Estimates of the Resident Population for the United States, Regions, States, the District of Columbia, and Puerto Rico: April 1, 2010 to July 1, 2019; April 1, 2020; and July 1, 2020 (NST-EST2020)". Washington, D.C.: US Census Bureau. [URL](https://www2.census.gov/programs-surveys/popest/tables/2010-2020/state/totals/)
5. United States Department of Housing and Urban Development. 2023. "2007 - 2023 PIT Estimates by State". Washington, D.C.: HUD. [URL](https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/)


## Currently working on: ##
- Cleaning up code to better adhere to best practices & improve readability
- Looking for the bottom of the rabbit hole of model assumption violations -_-
  
### General thoughts & comments ###

**2/28**: So far I don't think there's much evidence of filerate & homelesscap being significantly related in any way. But at the same time I am very out of my depth; both variables of interest seem very multimodal and I have not really worked with multimodal distributions before. Not sure if this rabbit hole will lead anywhere but oh well. And I'm still not 100% sure I understand the difference between the Least Squares Dummy Variable and within-fixed effects models so I'll just keep scouring the internet I guess!

I doubt I will get to the point of confidently drawing any conclusions from what I have here, at my current level of skill and experience (and with my distrust of this dataset (mostly the PIT, and also my methods of aggregation during the cleaning process)). I may pivot slightly and try going back to working with counties instead of states.


## Directory ##
- `data/`
    - `raw/` Datasets directly downloaded from above sources
        - `codebooks_etc/`
    - `half-processed/`
    - `homelesspanel.dta`
- `code/`
    - `1-combiningpops.py` Combines & cleans the Census population estimates
    - `2-datacleaning.do` Creates panel dataset
    - `3-explore.r`
    - `requirements.txt`
- `notebooks/`
    - `explore_model.rmd`
    - `explore_model.nb.html`
- `README.md`
