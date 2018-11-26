#input: 1. hitorical return data
#       2. SORR 
#       3. number of paths needed
#
#output: return paths for equity and equity
#        path_equity and path_FI are matrices with 342 rows (days of period) and n columns (number of path)

dt = dt1[, c(2,4)]
dt = na.omit(dt)
base = dt[order(dt$equity),]
n = nrow(base) # 342 period
equity_return = base$equity
FI_return = base$FI

size_bad_return = floor(0.3*n)
size_ok_return = n-size_bad_return

Simulated_Path_Given_SORR =
  function(sorr,m){
    index_bad = 1:floor(0.3*n) #102 periods
    index_ok = (floor(0.3*n)+1):n
    rand_index = matrix(0, nrow = n, ncol = m)
    path_equity = matrix(0, nrow = n, ncol = m)
    path_FI = matrix(0, nrow = n, ncol = m)
    
    for(i in 1:m){
      left_bad = sample(index_bad, size = floor(sorr*size_bad_return))
      right_bad = setdiff(index_bad, left_bad)
      left_ok = sample(index_ok, size = (1/2*n - floor(sorr*size_bad_return)))
      right_ok = setdiff(index_ok, left_ok)
      left = c(left_bad, left_ok)
      right = c(right_bad, right_ok)
      
      #rand_index[1:(1/2*size_bad_return),i] = left_bad
      #rand_index[(1/2*n+1):(1/2*n+sorr*size_bad_return),i] = right_bad
      #rand_index[(1/2*size_bad_return+1):(1/2*n),i] = left_ok
      #rand_index[(1/2*n+1/2*size_bad_return+1):n,i] = right_ok
      
      rand_index[(1:(1/2*n)),i] <- sample(left, size = length(left))
      rand_index[((1/2*n+1):n),i] <- sample(right, size = length(right))
    }
    
    for (i in 1:m) {
      for (j in 1:n) {
        path_equity[j,i] = equity_return[rand_index[j,i]]
        path_FI[j,i] = FI_return[rand_index[j,i]]
      }
    }
    return(list(path_equity,path_FI))
  }

gene_path <- Simulated_Path_Given_SORR(0.5,100)
path_equity <- gene_path[[1]]
path_FI <- gene_path[[2]]