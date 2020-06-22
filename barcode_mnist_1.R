#Initialising
n=5
#View test image
train$y[n]
#show_digit(train[n,])
#Grayscale image
Q = matrix(as.matrix(train[n,][-785]), nrow = 28)
image(Q[, 28:1],col = gray(12:1 / 12))
#Complement of this grayscale image
QC= 255 - Q
image(QC[, 28:1],col = gray(12:1 / 12))
#Computing Persistence diagrams for both
DiagQ <- gridDiag(FUNvalues= Q,maxdimension = 3, library = "GUDHI")
DiagQC <- gridDiag(FUNvalues= QC,maxdimension = 3, library = "GUDHI")
#Plotting both persistance diagrams
plot(DiagQ[["diagram"]], barcode = TRUE)
plot(DiagQC[["diagram"]], barcode = TRUE)
plot(DiagQ[["diagram"]])   
plot(DiagQC[["diagram"]])
#Plot landscape
x <- seq(0, 400, length = 1000) #domain
Land <- landscape(DiagQC[["diagram"]], dimension = 1, KK = 1, x)
Land1 <- landscape(DiagQ[["diagram"]], dimension = 1, KK = 1, x)
plot( x, Land1, type="l", col="red")
plot( x, Land, type = "l")

           
