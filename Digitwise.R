#Analysing Data for digits
train1 = subset(train, y==9)
k=dim(train1[1])[1]
c <- seq(1,k,1)
#vector of persistance diagrams
vQ=NULL
vQC=NULL
for(i in c)
{
  n=i
  Q = matrix(as.matrix(train1[n,][-785]), nrow = 28)
  QC= 255 - Q
  DiagQC <- gridDiag(FUNvalues= QC,maxdimension = 3, library = "GUDHI")
  vQC=c(vQC,DiagQC)
}
#Plotting Landscapes
Land <- landscape(vQC[1][["diagram"]], dimension = 1, KK = 1, tseq)
plot( x, Land, type="l", col="red", ylim= c(0,210) )

c=seq(2,k)
for(i in c)
{
  Land <- landscape(vQC[i][["diagram"]], dimension = 1, KK = 1, tseq)
  lines( x,Land , type="l", col="red")
}




