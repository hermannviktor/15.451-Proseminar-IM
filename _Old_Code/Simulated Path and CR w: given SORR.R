library('readxl')
dt <- read_excel("/Users/EllieLiu/Desktop/2018 Fall/Proseminar/Code/data.xlsx")


dt$Dates = as.Date(dt$Dates,"%Y-%m-%d")
dt = dt[, c(2,4)]
dt = na.omit(dt)
base = dt[order(dt$equity),]
n = nrow(base) # 342 period
equity_return = base$equity
FI_return = base$FI

size_bad_return = floor(0.3*n)
size_ok_return = n-size_bad_return

######################################
# generate multiple paths
# path matrices have 342 rows and 10k columns
Simulated_Path_Given_SORR =
  function(sorr,m){
    index_bad = 1:floor(0.3*n) #102 periods
    index_ok = (floor(0.3*n)+1):n
    rand_index = matrix(0, nrow = n, ncol = m)
    path_equity = matrix(0, nrow = n, ncol = m)
    path_FI = matrix(0, nrow = n, ncol = m)
    
    for(i in 1:m){
      left_bad = sample(index_bad, size = 1/2*size_bad_return)
      right_bad = setdiff(index_bad, left_bad)
      left_ok = sample(index_ok, size = 1/2*size_ok_return)
      right_ok = setdiff(index_ok, left_ok)
      
      rand_index[1:(1/2*size_bad_return),i] = left_bad
      rand_index[(1/2*n+1):(1/2*n+1/2*size_bad_return),i] = right_bad
      rand_index[(1/2*size_bad_return+1):(1/2*n),i] = left_ok
      rand_index[(1/2*n+1/2*size_bad_return+1):n,i] = right_ok
    }
    
    for (i in 1:m) {
      for (j in 1:n) {
        path_equity[j,i] = equity_return[rand_index[j,i]]
        path_FI[j,i] = FI_return[rand_index[j,i]]
      }
    }
    return(list(path_equity,path_FI))
  }

Simulated_Path_Given_SORR(0.5,10000)

## Input
y = 30      # years in retirement
n = y*12    # number of months
x = 0.10    # amount taken out per period
e = 100000  # endowment
w = 5       # years for sequence risk
m = 10000   # number of return paths
#infla_ave = mean(na.omit(inflation))  #monthly inflation
withdraw = e*0.04/12    #monthly withdraw

SORR_to_coverage = function(path_equity,path_FI,a,start_point,end_point,e,x,n,m) {
  #first glidepath, constant
  glidepath_one = matrix(0,nrow = n, ncol = 2)
  glidepath_one[,1] = a
  glidepath_one[,2] = 1-a
  
  #second glidepath
  glidepath_two = matrix(0,nrow = n, ncol = 2)
  rate = (end_point - start_point)/n  #changing rate
  glidepath_two[,1] = seq(from = start_point, to = end_point-rate, by = rate)
  glidepath_two[,2] = 1-glidepath_two[,1]
  
  init = e*x/12
  wealth = matrix(0,nrow = n, ncol = m)
  wealth[1,] = e
  
  #calculate wealth position at specific time point after withdraw
  for (j in 1:m) {
    for (i in 2:n) {
      wealth[i,j] = (wealth[i-1,j] * ((1+path_equity[i,j])*glidepath_one[i,1] + (1+path_FI[i,j])*glidepath_one[i,2])) - init   #change glide path to 2
    }
  }
  
  #calculate coverage ratio for every path
  cover = matrix(0, nrow = 1, ncol = m)
  for (i in 1:m) {
    cover[i] = sum(wealth[,i]>0)/n
  }
  
  cover_ratio = mean(cover)
  
  return(cover_ratio)
}

#test on different allocation
results = matrix(0,nrow=1,ncol=100)
for (i in 1:100) {
  a = i/100
  results[i] = SORR_to_coverage(path_equity,path_FI,a,0.2,0.5,100000,0.05,360,10000)
}
