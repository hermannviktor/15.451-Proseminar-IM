function [wealth, consumption, ret_tot] = simulate(ret_path,glide_path, x, e, n, infl_avg)
%Simulate performance of funds
%   Given return path and glide path

init = e*x/12;

for i = 1:size(ret_path,1)
    for j = 1:size(glide_path,1)
        ret_tot{i,j} = sum(ret_path{i,1}.*glide_path{j,1},2);
        wealth{i,j} = nan(n,1);
        wealth{i,j}(1,1) = e;
        for k = 2:n
            wealth{i,j}(k,1) = wealth{i,j}(k-1,1)* ...
                (1+ret_tot{i,j}(k-1,1))-init*(1+infl_avg)^(k-2);            
        end 
    end
end

consumption = nan(n,1);
for k = 2:n
    consumption(k-1,1) = init*(1+infl_avg)^(k-2);
end 

end

