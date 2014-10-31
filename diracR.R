#
# Dirac R
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
library(downloader)

#download(url="https://innovdirac.blob.core.windows.net/diracdata/dirac.json.gz", destfile="dirac.json.gz")

ifile <- "insights.json"
dfile <- "dirac.json"
insights <- fromJSON(ifile)
dirac <- fromJSON(dfile)

insights <- insights[, c("timestamp", "duration")]
dirac <- dirac[, c("timestamp", "wallClockTime")]
insights$timestamp1 <- round(insights$timestamp/1000)
dirac$timestamp1 <- round(dirac$timestamp/1000)

insights <- insights[c(-1)]
dirac <- dirac[c(-1)]

colnames(insights) <- c("duration", "timestamp")
colnames(dirac) <- c("wallClockTime", "timestamp")

aggDirac <- aggregate(dirac$wallClockTime, by=list(dirac$timestamp), FUN=sum)
colnames(aggDirac) <- c("timestamp", "wallClockTime")

aggInsights <- aggregate(insights$duration, by=list(insights$timestamp), FUN=sum)
colnames(aggInsights) <- c("timestamp", "duration")

aggInsights <- aggInsights[with(aggInsights, order(timestamp)),]
aggDirac <- aggDirac[with(aggDirac, order(timestamp)),]

m <- merge(aggInsights, aggDirac, by="timestamp")

cor.test(m$duration, m$wallClockTime, method="k")


#m <- ddply(merge(aggInsights, aggDirac, all.x=TRUE), 
#           .(USER_A, USER_B), summarise, ACTION=sum(ACTION))


#plot(data$DateTime, data$Sub_metering_1 + data$Sub_metering_2 + data$Sub_metering_3, 
#     type="n", xlab="", ylab="Energy sub-metering")
#lines(data$DateTime, data$Sub_metering_1, col="black")
#lines(data$DateTime, data$Sub_metering_2, col="red")