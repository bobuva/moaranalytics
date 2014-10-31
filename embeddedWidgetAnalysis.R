#
# embeddedWidgetAnalysis.R
#
# 1414560240293
# 1414625848738
#
# "name":"Controller/embedded_widget/show"
#
# start 1414560240
# end:  1414625848

library(jsonlite)
library(plyr)
library(ggplot2)

#download(url="https://s3-us-west-2.amazonaws.com/diracdata/insights.json", destfile="insights.json")
#download(url="https://s3-us-west-2.amazonaws.com/diracdata/dirac.json", destfile="dirac.json")

ifile <- "insights.json"
dfile <- "dirac.json"
insights <- fromJSON(ifile)
dirac <- fromJSON(dfile)

insights <- insights[, c("timestamp", "duration", "name")]
insights <- insights[insights$name == "Controller/embedded_widget/show", c("timestamp", "duration")]

dirac <- dirac[, c("timestamp", "wallClockTime")]
insights$timestamp1 <- round(insights$timestamp/1000)
dirac$timestamp1 <- round(dirac$timestamp/1000)

insights <- insights[c(-1)]
dirac <- dirac[c(-1)]

colnames(insights) <- c("duration", "timestamp")
colnames(dirac) <- c("wallClockTime", "timestamp")

aggDirac <- aggregate(dirac$wallClockTime, by=list(dirac$timestamp), FUN=mean)
colnames(aggDirac) <- c("timestamp", "wallClockTime")

aggInsights <- aggregate(insights$duration, by=list(insights$timestamp), FUN=mean)
colnames(aggInsights) <- c("timestamp", "duration")

aggInsights <- aggInsights[with(aggInsights, order(timestamp)),]
aggDirac <- aggDirac[with(aggDirac, order(timestamp)),]

m <- merge(aggInsights, aggDirac, by="timestamp")

correlation <- cor(m$duration, m$wallClockTime)

cat("Correlation between Dirac wall clock time and 'Controller/embedded_widget/show' Insights page view is ", correlation)
