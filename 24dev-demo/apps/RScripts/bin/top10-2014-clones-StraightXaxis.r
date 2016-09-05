#!/usr/bin/Rscript
print("Usage: ./sriptName.r")
print("R batch mode file for Linux. A conventional Bar chart with straight X axis labels") 
print("See ../docs/README.sh for release and license details")

d1 <- read.csv(file="../input/top10_vw_nursery_cuttings_2014.csv",head=T,sep=",")
# Without an image size, note the X axis labels
#png(filename="top10_vw_nursery_cuttings_2014.png")

# Now provide an image size which will ensure the x labels display
png(filename="../output/top10_vw_nursery_cuttings_2014.png", height=768, width=1024, bg="white")

mp <- barplot(d1$VS_and_PlusTrees, ylim=c(0,20), main="2014 Vigor Suvival Plus Clones", xlab="CloneID", ylab="Vigor Survival Plus Tree Score", border='red')
axis(1,at=mp,labels=d1$Clone_ID)

lines(mp,d1$nbr_of_replications,type="o",pch=19,lwd=2,col="blue")
lines(mp,d1$avg_collar_median_dia_mm,type="o",pch=19,lwd=2,col="black")

legend("topright", c("nbr_of_replications", "avg_collar_median_dia_mm"), lty=c(1,1), lwd=c(2.5,2.5), col=c("blue","black"))


dev.off() 

