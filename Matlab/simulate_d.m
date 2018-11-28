function [wealth, consumption, ret_tot] = simulate_d(ret_path,glide_path, x, e, n)
%Simulate performance of funds
%   Given return path and glide path

init = e*x/12;

for i = 1:size(ret_path,1)
    
    if mod(i, 1000) == 0
        disp(['Simulating return path ', num2str(i), ' of ', ...
            num2str(size(ret_path,1)), '...']);
    end
    
    for j = 1:size(glide_path,2)
        ret_tot{i,j} = sum(ret_path{i,1}(:,1:2).*glide_path{i,j},2);
        inf_multi = cumprod(ret_path{i,1}(:,3)+1,1);
        inf_multi(1,1) = 1;
        consumption{i,1} = init*inf_multi;
        wealth{i,j} = nan(n,1);
        wealth{i,j}(1,1) = e;
        for k = 2:n
            wealth{i,j}(k,1) = wealth{i,j}(k-1,1)* ...
                (1+ret_tot{i,j}(k-1,1))-consumption{i,1}(k-1,1);            
        end 
    end
end

end

