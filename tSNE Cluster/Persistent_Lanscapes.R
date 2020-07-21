#Persistent Landscapes
library(TDA)
library(pracma)
library(Rtsne)
library(umap)
library(dplyr)

c = seq(1,10000)
mean_0 = mean(barcode_0[c]) 
mean_1 = mean(barcode_1[c])

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

#considering 6 barcodes for dimension 0 and 2 for dimension 1
landscape_data = NULL
tseq <- seq(0, 400, length = 1000)
for(i in c)
{
  #Dimension 0 case
  vect=NULL
  for(j in seq(2,7))
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
  # if( i %%100 ==0)
  # {print(i)}
}

#save(landscape_data , file = "landscape.Rda")
land_data = t(array(landscape_data, dim = c(8,10000)))
land_dat = data.frame(land_data, digit[1:10000])

#t-sne on this data
set.seed(314)
land_data2 = distinct(data.frame(land_dat),X1,X2,X3,X4,X5,X6,X7,X8, .keep_all = TRUE)
Rt = Rtsne(normalize_input(as.matrix(land_data2[,-9])), dims =2)

colors= c(palette.colors(), "peachpuff")
plot(Rt$Y, col = colors[as.integer(land_data2$digit)] , main ="All digits")

#############Plots tSNE############################
#Plot digitwise
new = data.frame(Rt$Y, land_data2$digit.1.10000.)
for(i in seq(0,9))
{
  sub = subset(new, land_data2.digit.1.10000. == i)
  plot(sub[,-3], main = i , col = colors[1+i], xlim = c(-80,70), ylim= c(-80,70))
}

#plot loopwise
sub = subset(new, land_data2.digit.1.10000. == 0)
plot(sub[,-3], main = "All Digits" , col = colors[1], xlim = c(-80,70), ylim= c(-80,70))
for(i in c(6,8,9))
{
  sub = subset(new, land_data2.digit.1.10000. == i)
  points(sub[,-3], main = i , col = colors[1], xlim = c(-80,70), ylim= c(-80,70))
}

#plot without loops
sub = subset(new, land_data2.digit.1.10000. == 1)
plot(sub[,-3], main = "1,3,4,5,7" , col = colors[2], xlim = c(-80,70), ylim= c(-80,70))
for(i in c(1,3,4,5,7))
{
  sub = subset(new, land_data2.digit.1.10000. == i)
  points(sub[,-3], main = i , col = colors[2], xlim = c(-80,70), ylim= c(-80,70))
}

############UMAP####
#umap on this data
data.umap = umap(land_dat[,c(1,2,7,8)])

plot(data.umap$layout, col = colors[as.integer(land_data2$digit)] , main ="All digits", xlim = c(-30,30), ylim = c(-30,30))
data2 = data.umap$layout

#Plot digitwise
new = data.frame(data2, digit)
for(i in seq(0,9))
{
  sub = subset(new, digit == i)
  plot(sub[,-3], main = i , col = colors[1+i], xlim = c(-30,30), ylim= c(-30,30))
}


######Using L^2 norm to define distance between landscape functions
d = matrix(seq(0,0,length.out = 5000*5000), nrow = 5000, ncol = 5000)
tseq <- seq(0, 400, length = 1000)

for( i in seq(1,1000))
{
  for(j in seq(i+1,1000))
  {
    if(d[i,j] == 0)
    {
      #Dimension 0 case
      vect=NULL
      for(k in seq(2,7))
      {
       Land_i = landscape(vQC[i][["diagram"]], dimension = 0, KK = k, tseq = tseq)
        Land_j = landscape(vQC[j][["diagram"]], dimension = 0, KK = k, tseq = tseq)
        vect = c(vect,norm(2, Land_i - Land_j))
      }
    
      #Dimension 1 case
      if(barcode_1[i] == 0)
      {
        if(barcode_1[j] == 0)
        {
          vect = c(vect,0,0)
        }
        if(barcode_1[j]!= 0)
        {
          Land_j_1 = landscape(vQC[j][["diagram"]], dimension = 1, KK = 1, tseq = tseq)
          Land_j_2 = landscape(vQC[j][["diagram"]], dimension = 1, KK = 2, tseq = tseq)
          vect = c(vect, norm(2, Land_j_1), norm(2,Land_j_2))
        }
      }
      if(barcode_1[i] != 0)
      {
        if(barcode_1[j] == 0)
        {
          Land_i_1 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 1, tseq = tseq)
          Land_i_2 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 2, tseq = tseq)
          vect = c(vect, norm(2, Land_i_1), norm(2,Land_i_2))
        }
      
        if(barcode_1[j]!= 0)
        {
          Land_i_1 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 1, tseq = tseq)
          Land_i_2 = landscape(vQC[i][["diagram"]], dimension = 1, KK = 2, tseq = tseq)
          Land_j_1 = landscape(vQC[j][["diagram"]], dimension = 1, KK = 1, tseq = tseq)
          Land_j_2 = landscape(vQC[j][["diagram"]], dimension = 1, KK = 2, tseq = tseq)
          vect = c(vect, norm(2,Land_i_1 - Land_j_1), norm(2, Land_i_2 - Land_j_2))
        }
      }
    
      d[i,j] = pracma::Norm(vect, p=2)
      d[j,i] = d[i,j]
    }
      if(j %%100 ==0)
      {
        print(i)
        print(j)
      }
  }
}

save(d, file ="d.Rda")
