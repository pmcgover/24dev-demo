#!/usr/bin/Rscript

print("hello world")
x<-1:10
y<-21:30
png(filename="myfile.png", height=768, width=1024, bg="white")
plot(x,y) 			
plot(x,y,type="o") 	
plot(x,y,type="o",pch=19,lty=1,lwd=1) 


