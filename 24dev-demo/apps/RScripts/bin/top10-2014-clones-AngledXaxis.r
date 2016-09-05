#!/usr/bin/Rscript
print("Usage: ./sriptName.r")
print("R batch mode file for Linux. A conventional Bar chart with angled X axis labels") 
print("See ../docs/README.sh for release and license details")

# Load CSV data file with a header 
d1 <- read.csv(file="../input/top10_vw_nursery_cuttings_2014.csv",head=T,sep=",")
# You MUST load the output 
# png(filename="top10_vw_nursery_cuttings_2014.png", height=768, width=1024, bg="white") # A larger image that shows all X value labels
png(filename="../output/top10-2014-clones-AngledXaxis.png") # Smaller image that requires angled labels

# Load the data into a barplot 
mp <- barplot(d1$VS_and_PlusTrees, ylim=c(0,20), main="2014 Vigor Suvival Plus Clones", xlab="CloneID", 
      ylab="Vigor Survival Plus Tree Score", border='red', pch=19, col.lab="red", cex.lab=1.1)

# Clear the X axis and labels from the parameter list
par(xaxt="n") 
# Set the X axis via the mp barplot but no labels 
axis(1,at=mp,labels=FALSE)
# Reset the X axis labels and add a 45 degree angle
text(mp, -1, 10, labels=d1$Clone_ID, srt = 45, pos=1 , xpd=TRUE)

# Add data lines to provide context
lines(mp,d1$nbr_of_replications,type="o",pch=19,lwd=2,col="blue")
lines(mp,d1$avg_collar_median_dia_mm,type="o",pch=19,lwd=2,col="black")
# Add a legend for the above lines
legend("topright", c("nbr_of_replications", "avg_collar_median_dia_mm"), lty=c(1,1), lwd=c(2.5,2.5), col=c("blue","black"))

# Shut down the graphics device and suppress the null device output message
garbage <- dev.off()


