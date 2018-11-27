function [sorr] = sorr(ret_tot, w, n)
%Calculate SORR
%   Find reliable measure

%sorr = mean(ret_tot(n-w*12+1:end,1))/mean(ret_tot(1:w*12,1));
%sorr = mean(ret_tot(n-w*12+1:end,1))-mean(ret_tot(1:w*12,1));

b = 0.3;
[~, ind] = sort(ret_tot, 'ascend');
t = n*0.3; 

sorr = sum(ind(1:w*12)<=t)/t;

end

