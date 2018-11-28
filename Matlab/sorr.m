function [sorr] = sorr(ret_path_eq, w, n)
%Calculate SORR
%   Find reliable measure

%sorr = mean(ret_tot(n-w*12+1:end,1))/mean(ret_tot(1:w*12,1));
%sorr = mean(ret_tot(n-w*12+1:end,1))-mean(ret_tot(1:w*12,1));

b = 0.3;
[list, ind] = sort(ret_path_eq, 'ascend');
t = n*b; 

sorr = sum(ind(1:t)<=w*12)/t;

end

