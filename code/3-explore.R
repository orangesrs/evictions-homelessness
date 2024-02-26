library(haven)
#library(MASS)
library(ggplot2)
data = read_dta("homelesspanel.dta")

head(data)
sumstats = summary(data[c('filerate', 'homelesscap', 'chroniccap', 'red', 'blue')])
print(sumstats)

par(mfrow = c(1, 2))

hist(data$homelesscap, breaks = 40, 
     main = "Homelessness by state by year (homelesscap)", 
     xlab = 'homeless persons per 1,000 residents', 
     col = 'seashell', 
     cex.main = 0.7, 
     cex.lab = 0.7)

hist(data$filerate, breaks = 40, 
     main = 'Rate of eviction filings by state by year (filerate)', 
     xlab = 'eviction filings per 1,000 renting households', 
     col = 'lavender', 
     cex.main = 0.7, 
     cex.lab = 0.7)

par(mfrow = c(1, 2))

boxplot(data$homelesscap, 
        main = "Homelessness by state by year (homelesscap)", 
        ylab = 'homeless persons per 1,000 residents', 
        cex.main = 0.7, 
        cex.lab = 0.7, 
        col = 'seashell')

boxplot(data$filerate, 
        main = 'Eviction filings by state by year (filerate)', 
        ylab = 'eviction filings per 1,000 renting households', 
        cex.main = 0.7, 
        cex.lab = 0.7, 
        col = 'lavender')

base = ggplot(data = data, mapping = aes(x = filerate, y = homelesscap))

base + geom_point(size = 0.8) + 
  geom_smooth(method = 'lm', color = 'black', linewidth = .7) +
  geom_smooth(color = 'green', linewidth = .7) +
  labs(title = 'Scatterplot of rates of evictions filings & rates 
       of homelessness by state by year') +
  ylab('# homeless persons per 1,000 residents') +
  xlab('# eviction filings per 1,000 renting households')
