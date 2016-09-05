#!/usr/bin/Rscript
print("Usage: ./sriptName.r")
print("R batch mode file for Linux. Write a basic Hello World graph to: ../output/basicGraph.png")
print("See ../docs/README.sh for release and license details")

print("Hello World")
x<-1:10
y<-21:30
png(filename="../output/basicGraph.png", height=768, width=1024, bg="white")
plot(x,y) 			
plot(x,y,type="o") 	
plot(x,y,type="o",pch=19,lty=1,lwd=1) 


