function [path] = gen_ret_path(ret_e, ret_fi, infl, n)
%Generate random paths of returns
%   Paths where good returns happen first, bad returns first and average

%row = randi(size(ret_e,1), [n, 1]);
row = randperm(size(ret_e,1), n)';
path(:,1) = ret_e(row,1);
path(:,2) = ret_fi(row,1);
path(:,3) = infl(row,1);

end

