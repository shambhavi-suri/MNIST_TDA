library(TDA)
library(rgl)
library(quantmod)
library(pracma)
library(astsa)
library(tseriesChaos)
library(nonlinearTseries)

#####################Downloading Data & Log returns##########################

getSymbols(c("^GSPC","^DJI","^IXIC","^RUT"), from = "1995/1/1",to = "2021/1/1",periodicity = "daily")
log_returns <- cbind(diff(log(GSPC[,6])),diff(log(DJI[,6])),diff(log(IXIC[,6])),diff(log(RUT[,6])))[-1,]

####################Determine window and delay###############################

scales_lr <- scale(log_returns)

#ACF plots
acf(scales_lr$GSPC.Adjusted, lag.max = 10)
acf(scales_lr$DJI.Adjusted, lag.max = 10)
acf(scales_lr$IXIC.Adjusted, lag.max = 10)
acf(scales_lr$RUT.Adjusted, lag.max = 10)

tau_g_1 = timeLag(scales_lr$GSPC.Adjusted, technique = "acf", lag.max = 100, do.plot = T)
tau_g_2 = timeLag(scales_lr$GSPC.Adjusted, technique = "ami", lag.max = 100, do.plot = T)
tau_d_1 = timeLag(scales_lr$DJI.Adjusted, technique = "acf", lag.max = 100, do.plot = T)
tau_d_2 = timeLag(scales_lr$DJI.Adjusted, technique = "ami", lag.max = 100, do.plot = T)
tau_i_1 = timeLag(scales_lr$IXIC.Adjusted, technique = "acf", lag.max = 100, do.plot = T)
tau_i_2 = timeLag(scales_lr$IXIC.Adjusted, technique = "ami", lag.max = 100, do.plot = T)
tau_r_1 = timeLag(scales_lr$RUT.Adjusted, technique = "acf", lag.max = 100, do.plot = T)
tau_r_2 = timeLag(scales_lr$RUT.Adjusted, technique = "ami", lag.max = 100, do.plot = T)

##Sliding Window using tseriesChaos
# m: embedding Dimension and d: Delay time
plot_1 = false.nearest(test, d = 1, m = 20, t = 15)
plot(plot_1)

##Sliding Window using nonlinearTseries
test = ts(scales_lr$GSPC.Adjusted)
emb_dim_g = estimateEmbeddingDim(test)
test = ts(scales_lr$DJI.Adjusted)
emb_dim_d = estimateEmbeddingDim(test)
test = ts(scales_lr$IXIC.Adjusted)
emb_dim_i = estimateEmbeddingDim(test)
test = ts(scales_lr$RUT.Adjusted)
emb_dim_r = estimateEmbeddingDim(test) ##Embedding Dimension : 11

##Estimating Correlation dimension
test = ts(scales_lr$GSPC.Adjusted)
cd = corrDim(test,
             min.embedding.dim = 2,
             max.embedding.dim = 16,
             time.lag = 1, 
             min.radius = 0.001, max.radius = 50,
             n.points.radius = 40)
#cd.est = estimate(cd, regression.range=c(0.75,3),
                  #use.embeddings = 5:7)

#embedd from tserieschaos

point_cloud_g = embedd(ts(scales_lr$GSPC.Adjusted), m = emb_dim_g, d = tau_g_1)
point_cloud_d = embedd(ts(scales_lr$DJI.Adjusted), m = emb_dim_d, d = tau_d_1)
point_cloud_r = embedd(ts(scales_lr$RUT.Adjusted), m = emb_dim_r, d = tau_r_1)
point_cloud_i = embedd(ts(scales_lr$IXIC.Adjusted), m = emb_dim_i, d = tau_i_1)


