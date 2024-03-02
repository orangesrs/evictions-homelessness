library(haven)
library(ggplot2)
data = read_dta("homelesspanel.dta")

head(data)
sumstats = summary(data[c('filerate', 'homelesscap', 'chroniccap', 'red', 'blue')])
print(sumstats)


plot_template = function(data, type = "box", title, label, color = 'seashell') {
  # aesthetic theme for distribution visualizations.
  ## create named list of boxplot func & hist func
  plot_types = list(
    box = function(dt) {
      boxplot(dt, breaks = 40, 
              main = title, 
              xlab = label, 
              col = color, 
              cex.main = 0.7, 
              cex.lab = 0.7)},
    hist = function(dt) {
      hist(dt, breaks = 40, 
              main = title, 
              xlab = label, 
              col = color, 
              cex.main = 0.7, 
              cex.lab = 0.7)}
  )
  ## error handling
  if ( !(type %in% names(plot_types)) ) {
    stop("type must be 'box' or 'hist'")
  }
  # choose specified type of plot by indexing plot_types
  plotted = plot_types[[type]]
  plotted(data)
}


hlabel = 'homeless persons per 1,000 residents'
flabel = 'eviction filings per 1,000 renting households'

# visualize distributions of homelesscap & filerate
## side by side histograms
par(mfrow = c(1, 2))

plot_template(data$homelesscap, type = 'hist',
              title = "Homelessness by state by year (homelesscap)",
              label = hlabel)

plot_template(data$filerate, type = 'hist',
              title = 'Rate of eviction filings by state by year (filerate)',
              label = flabel,
              color = 'lavender')

## side by side boxplots
par(mfrow = c(1, 2))

plot_template(data$homelesscap,
              title = "Homelessness by state by year (homelesscap)",
              label = hlabel)

plot_template(data$filerate,
              title = 'Rate of eviction filings by state by year (filerate)',
              label = flabel,
              color = 'lavender')


# visualize relationship between homelesscap & filerate
base = ggplot(data = data, mapping = aes(x = filerate, y = homelesscap))

base + geom_point(size = 0.8) + 
  geom_smooth(method = 'lm', color = 'black', linewidth = .7) +
  geom_smooth(color = 'green', linewidth = .7) +
  labs(title = 'Scatterplot of rates of evictions filings & rates 
       of homelessness by state by year') +
  ylab(hlabel) +
  xlab(flabel)
