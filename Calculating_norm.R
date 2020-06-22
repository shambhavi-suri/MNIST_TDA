#Finding norm of landscape
#norm_i_j denotes jth norm of 1st landscape function of dimension i
norm_0_1 = NULL  
norm_1_1 = NULL
norm_0_2 = NULL
norm_1_2 = NULL
train_dim= dim(train)
c =seq(1,train_dim[1])
x <- seq(0, 400, length = 1000)
#We have vQC an array of persistent diagrams of the complements
for(i in c)
{
  Land_0 <- landscape(vQC[i][["diagram"]], dimension = 0, KK = 1, x) 
  Land_1 <- landscape(vQC[i][["diagram"]], dimension = 1, KK = 1, x)
  norm_0_1 = c(norm_0_1, norm(1,Land_0))
  norm_1_1 = c(norm_1_1, norm(1,Land_1))
  norm_0_2 = c(norm_0_2, norm(2,Land_0))
  norm_1_2 = c(norm_1_2, norm(2,Land_1))
}
norm_landscape = data.frame(norm_0_1, norm_1_1, norm_0_2, norm_1_2)

