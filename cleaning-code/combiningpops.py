import pandas as pd

# load in 2000-2010 population estimates
pop1 = pd.read_csv('st-est00int-01.csv')

### grab desired rows (states only) & columns (years 2008 and 2009)
pop1_89 = pop1.iloc[8:59, [0, 10, 11]]

### rename columns
varnames = {'table with row headers in column A and column headers in rows 3 through 4. (leading dots indicate sub-parts)': 'state', 
            'Unnamed: 10': 'y2008', 'Unnamed: 11': 'y2009'}
pop1_89 = pop1_89.rename(columns = varnames)

### get rid of the period before each state name
pop1_89['state'] = pop1_89['state'].str.strip('.')
pop1_89['y2008'] = pop1_89['y2008'].str.replace(',', '').astype(int)
pop1_89['y2009'] = pop1_89['y2009'].str.replace(',', '').astype(int)

# repeat for 2010-2020
pop2 = pd.read_excel('nst-est2020.xlsx')

cols = [0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
pop2_1018 = pop2.iloc[8:59, cols]

varnames = {'table with row headers in column A and column headers in rows 3 through 4. (leading dots indicate sub-parts)': 'state',
            'Unnamed: 3': 'y2010', 'Unnamed: 4': 'y2011', 'Unnamed: 5': 'y2012', 'Unnamed: 6': 'y2013', 'Unnamed: 7': 'y2014',
              'Unnamed: 8': 'y2015', 'Unnamed: 9': 'y2016', 'Unnamed: 10': 'y2017', 'Unnamed: 11': 'y2018', 'Unnamed: 12': 'y2019'}
pop2_1018 = pop2_1018.rename(columns=varnames)

pop2_1018['state'] = pop2_1018['state'].str.strip('.')

# merge the dataframes using state as key
popests = pd.merge(pop1_89, pop2_1018, how = 'inner', on = 'state')

# export to csv
popests.to_csv('popests.csv')