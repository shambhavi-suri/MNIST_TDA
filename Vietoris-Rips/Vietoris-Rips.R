#Vietoris Rips Complex
library(TDA)
library(scatterplot3d)
library(pracma)

#defining L^p(R) norm
tseq = seq(0,1,length = 1000)
norm = function(p,Land)
{
  p <<- p #setting global variable
  #linear interpolation to get landscape function
  fun_land = approxfun(tseq, Land, method = "linear") 
  fun_land_p = function(x)
  {
    fun_land(x)^p
  }
  #integrating f^p from 0 to 1
  integral_p = integral(fun_land_p, xmin= 0 , xmax = 1) #pracma library
  #the function returns pth root of integral
  integral_p^(1/p)
}

#Computing Persistence diagrams
c = seq(1, 1000)
Diagr = NULL
for(i in c)
{
  x = NULL
  y = NULL
  z1 = NULL
  z = NULL
  Q = matrix(as.matrix(train[i,-785]), nrow=28)
  len = seq(1,28,1)
  for(j in len)
  {
    for(k in len)
    {
      if(Q[j,k] > 0)
      {
        x = c(x,k/28)
        y = c(y,j/28)
        z1 = c(z1,Q[j,k])
      }
    }
  }
  z = (z1 - mean(z1))/sd(z1)
  dat = data.frame(x,y,z)
  DiagRips <- ripsDiag(X = dat, maxdimension = 1, maxscale = 1, library = "GUDHI")
  #plot(x = DiagRips[["diagram"]], main = "Rips Diagram" , barcode = TRUE)
  Diagr = c(Diagr, DiagRips)
}

#Calculating norms
norm_0_1 = NULL  
norm_1_1 = NULL
norm_0_2 = NULL
norm_1_2 = NULL

#Calculating norms for 0 dimension
for(i in c)
{
  x_0_1 = NULL #Array of 1-norms of landscape functions
  x_0_2 = NULL #Array of 2-norms of landscape functions
  c_2 = seq(2,4,1) #Dimension of array: # of 0 barcodes
  for(j in c_2)
  {  
    Land_0 <- landscape(Diagr[i][["diagram"]], dimension = 0, KK = j, tseq=tseq)
    x_0_1 = c(x_0_1, norm(1, Land_0))
    x_0_2 = c(x_0_2, norm(2, Land_0))
  }
  norm_0_1 = c(norm_0_1, pracma::Norm(x_0_1,1)) #using norm from pracma
  norm_0_2 = c(norm_0_2, pracma::Norm(x_0_2,2)) #Gives p-norm of array
  if( i%%100 == 0)
  {print(i)}
}

save(norm_0_1,file = "norm_0_1_6.Rda")
save(norm_0_2,file = "norm_0_2_6.Rda")

#Calculating norms for dimension 1
for(i in c)
{
  x_1_1 = NULL
  x_1_2 = NULL
  c_2 = seq(1,4,1)
  for(j in c_2)
  {  
    Land_1 <- landscape(Diagr[i][["diagram"]], dimension = 1, KK = j, tseq)     
    x_1_1 = c(x_1_1, norm(1, Land_1))
    x_1_2 = c(x_1_2, norm(2, Land_1))
  }
  norm_1_1 = c(norm_1_1, pracma::Norm(x_1_1,1)) #using norm from pracma
  norm_1_2 = c(norm_1_2, pracma::Norm(x_1_2,2))
  print(i)
}

save(norm_1_1,file = "norm_1_1_6.Rda")
save(norm_1_2,file = "norm_1_2_6.Rda")

x = scale(norm_0_2, scale = TRUE, center = TRUE)
y = scale(norm_1_2, scale = TRUE, center = TRUE)
digit= train$y[1:1000]
norm_landscape_6 = data.frame(x,y,digit)

#Plotting norms
colors = c(palette(),"slategray2","peachpuff3")
dat = norm_landscape_6
sub = subset(dat, digit == 0)
plot(sub$x, sub$y , main= "All Digits", col = colors[1], xlab = "norm02", ylab="norm12")
for(i in seq(1,9,1))
{
  sub = subset(dat, digit == i)
  points(sub$x, sub$y, col = colors[i+1])
}

#Plotting Barcodes
for(i in seq(0,9))
{
  for(j in seq(1,20))
  {
    if(train$y[j]==i)
    {
      plot(x = Diagr[j][["diagram"]], main = i , barcode = TRUE)
      break()      
    }
  }
}
