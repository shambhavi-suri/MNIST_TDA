#image analysis
library(plot.matrix)
library(TDA)
library(pracma)
library(Rtsne)
library(umap)
library(dplyr)
library(dimRed)
library(ggfortify)

average_matrix <- function(W)
{
  n = nrow(W)
  S = matrix(seq(0,0,length.out = 4*n*n), nrow = 2*n)
  
  for(i in seq(1,n))
  {
    for(j in seq(1,n))
    {
      S[2*i-1, 2*j-1] = W[i,j]
      S[2*i-1, 2*j] = W[i,j]
      S[2*i, 2*j-1] = W[i,j]
      S[2*i, 2*j] = W[i,j]
    }
  }
  
  R = matrix(seq(0,0,length.out = 4*n*n), nrow = 2*n)
  for(i in seq(2,2*n -1))
  {
    for(j in seq(2,2*n -1))
    {
      R[i,j] = round((S[i-1,j-1]+S[i-1,j]+S[i-1,j+1]+S[i,j-1]+S[i,j+1]+S[i+1,j-1]+S[i+1,j]+S[i+1,j+1]+S[i,j])/9)
    }
  }
  
  for(k in seq(2,2*n -1))
  {
    R[1,k] = round((S[1,k-1]+S[2,k-1]+S[1,k]+S[2,k]+S[1,k+1]+S[2,k+1])/6)
    R[k,1] = round((S[k-1,1]+S[k-1,2]+S[k,1]+S[k,2]+S[k+1,1]+S[k+1,2])/6)
    R[2*n,k] = round((S[2*n,k-1]+S[2*n-1,k-1]+S[2*n,k]+S[2*n-1,k]+S[2*n,k+1]+S[2*n-1,k+1])/6)
    R[k,2*n] = round((S[k-1,2*n]+S[k-1,2*n-1]+S[k,2*n]+S[k,2*n-1]+S[k+1,2*n]+S[k+1,2*n-1])/6)
  }
  R[1,1] = round((S[1,1]+S[1,2]+S[2,1]+S[2,2])/4)
  R[2*n,1] = round((S[2*n,1]+S[2*n,2]+S[2*n-1,1]+S[2*n-1,2])/4)
  R[1,2*n] = round((S[1,2*n]+S[1,2*n-1]+S[2,2*n]+S[2,2*n-1])/4)
  R[2*n, 2*n] = round((S[2*n,2*n]+S[2*n,2*n-1]+S[2*n-1,2*n]+S[2*n-1,2*n-1])/4)
  return(R)
}

n1 = 3

data = NULL
Q = matrix(as.matrix(train[1,-785]), nrow = 28)[,28:1]
R = Q
for( i in seq(1,n1))
{
  R = average_matrix(R)
}
data = data.frame(t(as.vector(R)))

for(i in seq(2,5000))
{
  Q = matrix(as.matrix(train[i,-785]), nrow = 28)[,28:1]
  R = Q
  
  for( j in seq(1,n1))
  {
    R = average_matrix(R)
  }
  data = rbind(data, c(R))
  if(i %% 100 == 0)
    {
      save(data, file = "train_data.Rda")
      print(i)
  }
}


# Q1 = matrix(as.matrix(data[i,]), nrow = nrow(Q)*(2**n))
# image(Q1 , col = gray(1:12/12))

m = 5000
digit = train$y[1:m]

#barcodes digitwise
for(i in seq(0,9))
{
  for(j in seq(1,20))
  {
    if(digit[j] == i)
    {
      Q1 = (matrix(as.matrix(data[j,]), nrow = 224))
      #plot(255- Q1, main = i)
      image(255 - Q1, col = gray(1:12/12))
      DiagQ <- gridDiag(FUNvalues = 255- Q1 ,maxdimension = 2, library = "GUDHI")
      plot(DiagQ[["diagram"]], main = i)
      plot(DiagQ[["diagram"]], main = i , barcode = TRUE)
      break()
    }
  }
}

pdiagrams = NULL
#Persistent diagrams for data
for(k in seq(3166,5000))
{
  Q1 = (matrix(as.matrix(data[k,]), nrow = 224))
  DiagQ <- gridDiag(FUNvalues = 255- Q1 ,maxdimension = 2, library = "GUDHI")
  pdiagrams = c(pdiagrams, DiagQ)
  if(k %% 100 == 0)
  {
    print(k)
    save(pdiagrams , file = "pdiagrams.Rda")
  }
}

#save(pdiagrams , file = "pdiagrams.Rda")

#Finding no of barcodes corresponding to dimension 0 and 1
barcode_0 = NULL
barcode_1 = NULL

c=seq(1,5000)
for(i in c)
{
  l= pdiagrams[i][["diagram"]]
  n_1 = length(l)/3
  c_1 = seq(n_1 , 1 , -1)
  for(j in c_1)
  {
    if(l[j] == 0)
    {
      n_0 = j
      break
    }
  }
  n_1 = length(l)/3 - n_0
  barcode_0 = c(barcode_0, n_0)
  barcode_1 = c(barcode_1, n_1)
}
save(barcode_0 , file = "barcode_0.Rda")
save(barcode_1 , file = "barcode_1.Rda")

#Persistent landscapes

#Norm
norm = function(p,Land)
{
  p <<- p #setting global variable
  #linear interpolation to get landscape function
  fun_land = approxfun(tseq, Land, method = "linear") 
  fun_land_p = function(x)
  {
    abs(fun_land(x))^p
  }
  #integrating f^p from 0 to 300
  integral_p = integral(fun_land_p, xmin= 0 , xmax = 300) #pracma library
  #the function returns pth root of integral
  integral_p^(1/p)
}

#considering 2 KK values: 2,3 for dimension 0 and KK values: 1,2 for dimension 1
landscape_data = NULL
vQC = pdiagrams

tseq <- seq(0, 300, length = 1000)
for(i in c)
{
  #Dimension 0 case
  vect=NULL
  for(j in seq(2,3))
  {
    Land = landscape(vQC[i][["diagram"]], dimension = 0, KK = j, tseq = tseq)
    vect = c(vect,norm(2, Land))
  }
  
  #Dimension 1 case
  if(barcode_1[i] == 0)
  {
    vect = c(vect,0,0)
  }
  if(barcode_1[i] != 0)
  {
    Land1 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 1, tseq = tseq)
    Land2 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 2, tseq = tseq)
    vect = c(vect,norm(2, Land1),norm(2,Land2))
  }
  landscape_data = c(landscape_data,vect)
  if( i %% 100 ==0)
    print(i)
}

land_data = t(array(landscape_data, dim = c(4,5000)))
land_dat = data.frame(land_data, digit)
save(land_data , file = "landscape_data.Rda")

#T-Sne
set.seed(314)
land_data2 = distinct(land_dat,X1,X2,X3,X4, .keep_all = TRUE)
Rt = Rtsne(normalize_input(as.matrix(land_data2[,-5])), dims =2)

colors= c(palette.colors(), "peachpuff3")
plot(Rt$Y, col = colors[as.integer(land_data2$digit)] , main ="All digits")

new = data.frame(Rt$Y, land_data2$digit)
for(i in seq(0,9))
{
  sub = subset(new, land_data2.digit == i)
  plot(sub[,-3], main = i , col = colors[1+i], xlim = c(-50,50), ylim= c(-50,55))
}

#umap and pca
umap.data = umap(normalize_input(as.matrix(land_data)))
#complete plot
plot(data.frame(umap.data$layout), main = "All digits", col = colors[as.integer(digit)])
plot(data.frame(umap.data$layout), main = "All digits (resized)", col = colors[as.integer(digit)], xlim = c(-20,20), ylim = c(-20,20))

#plot digitwise
plot_data = data.frame(umap.data$layout , digit)
sub = subset(plot_data , digit == 0)
plot(sub[,-3], main = 0, col = colors[1], xlim = c(-20,20), ylim = c(-20,20))
for(i in seq(1,9))
{
  sub = subset(plot_data , digit == i)
  plot(sub[,-3], main = i, col = colors[i+1], xlim = c(-20,20), ylim = c(-20,20))
}

#PCA plot
data.pca = prcomp(normalize_input(as.matrix(land_data)))
autoplot(data.pca, data = normalize_input(as.matrix(land_data)))

#Dimension 1 plots
data_h1= normalize_input(as.matrix(land_data[,3:4]))
plot(data_h1 , col = colors[as.integer(digit)], xlab = "L2 norm of 1st landscape", ylab = "L2 norm of 2nd landscape", main = "H_1 landscape plots (Normalised)")

#considering 4 KK values: 2,3,4,5 for dimension 0 and KK values: 1,2 for dimension 1

landscape_data_2 = NULL
vQC = pdiagrams

tseq <- seq(0, 300, length = 1000)
for(i in c)
{
  #Dimension 0 case
  vect=NULL
  for(j in seq(2,5))
  {
    Land = landscape(vQC[i][["diagram"]], dimension = 0, KK = j, tseq = tseq)
    vect = c(vect,norm(2, Land))
  }
  
  #Dimension 1 case
  if(barcode_1[i] == 0)
  {
    vect = c(vect,0,0)
  }
  if(barcode_1[i] != 0)
  {
    Land1 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 1, tseq = tseq)
    Land2 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 2, tseq = tseq)
    vect = c(vect,norm(2, Land1),norm(2,Land2))
  }
  landscape_data_2 = c(landscape_data_2,vect)
  if( i %% 100 ==0)
    print(i)
}

land_data_2 = t(array(landscape_data_2, dim = c(6,5000)))
land_dat_2 = data.frame(land_data_2, digit)
save(land_data_2 , file = "landscape_data_2.Rda")

#T-Sne
set.seed(314)
land_data2_2 = distinct(land_dat_2,X1,X2,X3,X4,X5,X6, .keep_all = TRUE)
Rt = Rtsne(normalize_input(as.matrix(land_data2_2[,-7])), dims =2)

colors= c(palette.colors(), "peachpuff3")
plot(Rt$Y, col = colors[as.integer(land_data2_2$digit)] , main ="All digits")

new = data.frame(Rt$Y, land_data2_2$digit)
for(i in seq(0,9))
{
  sub = subset(new, land_data2_2.digit == i)
  plot(sub[,-3], main = i , col = colors[1+i], xlim = c(-50,50), ylim= c(-50,55))
}

#umap and pca
umap.data = umap(normalize_input(as.matrix(land_data_2)))
#complete plot
plot(data.frame(umap.data$layout), main = "All digits", col = colors[as.integer(digit)])
plot(data.frame(umap.data$layout), main = "All digits ", col = colors[as.integer(digit)], xlim = c(-20,20), ylim = c(-20,20))

#plot digitwise
plot_data = data.frame(umap.data$layout , digit)
sub = subset(plot_data , digit == 0)
plot(sub[,-3], main = 0, col = colors[1], xlim = c(-20,20), ylim = c(-20,20))
for(i in seq(1,9))
{
  sub = subset(plot_data , digit == i)
  plot(sub[,-3], main = i, col = colors[i+1], xlim = c(-20,20), ylim = c(-20,20))
}

#PCA plot
data.pca = prcomp(normalize_input(as.matrix(land_data_2)))
autoplot(data.pca, data = normalize_input(as.matrix(land_data_2)), colour = colors[as.integer(digit)])

