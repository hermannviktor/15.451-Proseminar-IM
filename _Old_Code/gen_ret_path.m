function [path] = gen_ret_path(ret_e, ret_fi, n)
%Generate paths of returns of certain sorr
%   Paths where good returns happen first, bad returns first and average

row = randi(size(ret_e,1), [n, 1]);
path(:,1) = ret_e(row,1);
path(:,2) = ret_fi(row,1);

end

