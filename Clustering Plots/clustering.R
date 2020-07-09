library(dbscan)
library(dplyr)
library(meanShiftR)

##################Data Set#################################
#The norm plots is first normalized and then norm 
#corresponding to dim 1 is scaled to weight the variable


#Normalized data set
x= scale(norm01, center =TRUE, scale =TRUE)
y= scale(norm11, center =TRUE, scale =TRUE)
np1 = data.frame(x,y)
x= scale(norm02, center =TRUE, scale =TRUE)
y= scale(norm12, center =TRUE, scale =TRUE)
np2 = data.frame(x,y)

#scale for np1 = 2
x= np1$x
y=np1$y*2
scnp1 = data.frame(x,y)

#Scale for np2  = 3.25
x= np2$x
y=np2$y*3.25
scnp2 = data.frame(x,y)

###############Hdbscan#########################################
#HDBSCAN clustering is run on subsample of 10000 elements

set.seed(3142)
ndatatotal = data.frame(scnp2,digits)
ndata= slice_sample(ndatatotal, n = 10000)

h = hdbscan(ndata[,-3], minPts = 35)
dat = data.frame(ndata, h$cluster)
for( i in seq(0,18,1))  
{
  sub = subset(dat,h$cluster==i)
  cat("Cluster", i ,"\n")
  print(summary(sub$digits))    
  cat("\n")
}

########meanshift###############################################
#HDBSCAN clustering is run on subsample of 20000 elements
set.seed(3142)
ndatatotal = data.frame(scnp2,digits)
ndata= slice_sample(ndatatotal, n = 20000)

m = meanShift(as.matrix(ndata[,-3]), nNeighbors = 6000)
dat = data.frame(ndata, m$assignment)
n = range(m$assignment)[2]
k=0
j =1
for( i in seq(1,n,1))  
{
  sub = subset(dat,m$assignment==i)
  if(dim(sub)[1] >=40)
  {
    cat("Cluster", j ,"\n")
    print(summary(sub$digits))
    cat("\n")
    k = k + dim(sub)[1]
    j = j+1
  }
}

#########################DBSCAN################################
#HDBSCAN clustering is run on subsample of 20000 elements
#scnp2
set.seed(3142)
ndatatotal = data.frame(scnp2,digits)
ndata= slice_sample(ndatatotal, n = 20000)

kNNdistplot(ndata[,-3],k=4)
abline(h = 0.15, lty = 2)

#iteration 1
f = dbscan::dbscan(ndata[,-3], eps = 0.15 , minPts = 40)

data1 = data.frame(ndata,f$cluster)
for( i in c(0,1,2,3))
{
  clusterwise = subset(data1,f.cluster == i)
  cat("Cluster number", i)
  cat("\n")
  print(summary(clusterwise$digits))
  cat("\n")
}

#iteration 2 for cluster 1
clusterwise = subset(data1,f.cluster == 1)
h = dbscan::dbscan(clusterwise[,1:2], eps = 0.15 , minPts = 70)
data2 = data.frame(clusterwise[,1:3],h$cluster)
for(i in c(0,1,2,3))
{
  clusterwise1 = subset(data2,h.cluster == i)
  cat("Cluster number", i)
  cat("\n")
  print(summary(clusterwise1$digits))
  cat("\n")
}

#iteration 2 for cluster 2
clusterwise = subset(data1,f.cluster == 2)
h = dbscan::dbscan(clusterwise[,1:2], eps = 0.15 , minPts = 750)
data2 = data.frame(clusterwise[,1:3],h$cluster)
for(i in c(0,1))
{
  clusterwise1 = subset(data2,h.cluster == i)
  cat("Cluster number", i)
  cat("\n")
  print(summary(clusterwise1$digits))
  cat("\n")
}


#scnp1
set.seed(3142)
ndatatotal = data.frame(scnp1,digits)
ndata= slice_sample(ndatatotal, n = 20000)

kNNdistplot(ndata[,-3],k=4)
abline(h = 0.15, lty = 2)

#iteration 1
f = dbscan::dbscan(ndata[,-3], eps = 0.15 , minPts = 50)

data1 = data.frame(ndata,f$cluster)
for( i in c(0,1,2,3,4))
{
  clusterwise = subset(data1,f.cluster == i)
  cat("Cluster number", i)
  cat("\n")
  print(summary(clusterwise$digits))
  cat("\n")
}

#iteration 2 for clusters
clusterwise = subset(data1,f.cluster == 1)
h = dbscan::dbscan(clusterwise[,1:2], eps = 0.15 , minPts = 65)
data2 = data.frame(clusterwise[,1:3],h$cluster)
for(i in c(0,1,2))
{
  clusterwise1 = subset(data2,h.cluster == i)
  cat("Cluster number", i)
  cat("\n")
  print(summary(clusterwise1$digits))
  cat("\n")
}

# iteration 3
clusterwise1 = subset(data2,h.cluster == 2)
h1 = dbscan::dbscan(clusterwise1[,1:2], eps = 0.15 , minPts = 500)
data3 = data.frame(clusterwise1[,1:3],h1$cluster)
for(i in c(0,1))
{
  clusterwise2 = subset(data3,h1.cluster == i)
  cat("Cluster number", i)
  cat("\n")
  print(summary(clusterwise2$digits))
  cat("\n")
}







