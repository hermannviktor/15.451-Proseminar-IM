# input: 1. given return paths of both equity and fixed income for the period of time
#        2. asset allocation glidepath
#        3. retirement fund starting balance and withdraw rate
#        4. number of paths
#
# output: coverage ratio distribution for given glidepath and SORR


SORR_to_coverage_dist = function(path_equity,path_FI,a,start_point=0,end_point=0,e,x,n,m) {
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
  withdraw[1] = init
  
  for (i in 2:nrow(dt)) {
    withdraw[i] = withdraw[i-1] * (1+dt1$inflation[i])
  }
  
  wealth = matrix(0,nrow = n, ncol = m)
  wealth[1,] = e
  
  #calculate wealth position at specific time point after withdraw
  for (j in 1:m) {
    for (i in 2:n) {
      wealth[i,j] = (wealth[i-1,j] * ((1+path_equity[i,j])*glidepath_one[i,1] + (1+path_FI[i,j])*glidepath_one[i,2])) - withdraw[i]   #change glide path to 2
    }
  }
  
  # calculate coverage ratio for every path
  # if wealth at 30 year is still positive, coverage ratio > 1
  cover = matrix(0, nrow = 1, ncol = m)
  for (i in 1:m) {
    if (wealth[nrow(wealth),i]<0) {
      cover[i] = sum(wealth[,i]>0)/n
    }
    else {
      cover[i] = (n+(wealth[nrow(wealth),i]/init))/n
    }
  }
  
  #cover_ratio = mean(cover)
  
  return(cover)
}
