library('readxl')

#read data
# first column date
# second column equity return
# fourth column fixed income return
dt1 <- read_excel("Desktop/MIT/Fall2018/Proseminar/data/clean data/data.xlsx")
dt1$Dates = as.Date(dt1$Dates,"%Y-%m-%d")


######################################
gene_path <- Simulated_Path_Given_SORR(0.7,100000)
path_equity <- gene_path[[1]]
path_FI <- gene_path[[2]]


#test on different allocation
results = matrix(0,nrow=1,ncol=100)
for (i in 1:100) {
  a = i/100
  results[i] = SORR_to_coverage(path_equity,path_FI,a,0.2,0.5,100000,0.04,342,100)
}

hist(results)
plot(results[1,],type='l')


#plot coverage ratio histogram for given SORR and glidepath
results_hist = SORR_to_coverage_dist(path_equity = path_equity,path_FI = path_FI, a=0.6,e=100000,x=0.04,n=342,m=10000)
hist(results_hist, breaks = 12, xlab = 'Coverage Ratio', main = 'SORR=0.7 / Equity proportion = 0.6')
