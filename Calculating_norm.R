library(pracma)
library(TDA)

#defining L^p(R) norm
norm = function(p,Land)
{
  p <<- p #setting global variable
  #linear interpolation to get landscape function
  fun_land = approxfun(x, Land, method = "linear") 
  fun_land_p = function(x)
  {
    fun_land(x)^p
  }
  #integrating f^p from 0 to 300
  integral_p = integral(fun_land_p, xmin= 0 , xmax = 300) #pracma library
  #the function returns pth root of integral
  integral_p^(1/p)
}

#Finding no of barcodes corresponding to dimension 0 and 1
barcode_0 = NULL
barcode_1 = NULL
c=seq(1,dim(train)[1])
for(i in c)
{
  Q = matrix(as.matrix(train[i,][-785]), nrow = 28)
  QC= 255 - Q
  DiagQC_1 <- gridDiag(FUNvalues= QC,maxdimension = 1, library = "GUDHI")
  #l = class : diagram ; list of 3 attributes dim, birth, death
  l= DiagQC_1[["diagram"]] 
  #n_1 = # of barcodes of dimension 1 or less
  n_1 = length(DiagQC_1$diagram)/3 #n_1 = #of barcodes of dimension 1 or less
  c_1 = seq(n_1 , 1 , -1)
  #calculating # of barcodes 0 dimension
  for(j in c_1)
  {
    if(l[j] == 0)
    {
      n_0 = j
      break
    }
  }
  #n_1 = # of barcodes dim 1
  n_1 = length(DiagQC_1$diagram)/3 - n_0
  barcode_0 = c(barcode_0, n_0)
  barcode_1 = c(barcode_1, n_1)
}

#save(barcode_0 , file = "barcode_0.Rda")
#save(barcode_1 , file = "barcode_1.Rda")

########### Calculating norms ###########################

norm_0_1 = NULL  
norm_1_1 = NULL
norm_0_2 = NULL
norm_1_2 = NULL
c =seq(1,dim(train)[1])
x <- seq(0, 400, length = 1000)
#We have vQC an array of persistent diagrams of the complements
#Calculating norms for 0 landscape
for(i in c)
{
  x_0_1 = NULL #Array of 1-norms of landscape functions of dim 0 
  x_0_2 = NULL #Array of 2-norms of landscape functions of dim 0
  c_2 = seq(1,barcode_0[i]) # Dimension of array = # of 0 barcodes
  for(j in c_2)
  {  
    Land_0 <- landscape(vQC[i][["diagram"]], dimension = 0, KK = j, x)
    x_0_1 = c(x_0_1, norm(1, Land_0))
    x_0_2 = c(x_0_2, norm(2, Land_0))
  }
  norm_0_1 = c(norm_0_1, pracma::Norm(x_0_1,1)) #using norm from pracma
  norm_0_2 = c(norm_0_2, pracma::Norm(x_0_2,2)) #Gives p-norm of array
  #if( i%%1000 == 0)
  #  {print(i)}
}

#save(norm_0_1,file = "norm_0_1_4.Rda")
#save(norm_0_2,file = "norm_0_2_4.Rda")

################Calculating norms for dimension 1###############
for(i in c)
{
  x_1_1 = NULL
  x_1_2 = NULL
  if(barcode_1[i]==0)
  {
    norm_1_1 = c(norm_1_1,0)
    norm_1_2 = c(norm_1_2,0)
  }
  if(barcode_1[i] != 0)
  {
    c_2 = seq(1,barcode_1[i],1)
    for(j in c_2)
    {  
      Land_1 <- landscape(vQC[i][["diagram"]], dimension = 1, KK = j, x)
      x_1_1 = c(x_1_1, norm(1, Land_1))
      x_1_2 = c(x_1_2, norm(2, Land_1))
    }
    norm_1_1 = c(norm_1_1, pracma::Norm(x_1_1,1)) #using norm from pracma
    norm_1_2 = c(norm_1_2, pracma::Norm(x_1_2,2))
  }
  #print(i)
}

#save(norm_1_1,file = "norm_1_1_4.Rda")
#save(norm_1_2,file = "norm_1_2_4.Rda")

#creating dataframe norm_landscaope_4
norm_landscape_4 = data.frame(norm_0_1,norm_1_1,norm_0_2,norm_1_2) #This is saved  in norm_landscape_4.Rda

#summary of norms digitwise
s = train$y
normdata = data.frame(norm_landscape_4,s)
#subsetting data 
c = seq(0,9,1)
for(i in c)
{
  train1 = subset(normdata, normdata$s == i)
  print(summary(train1))
}

