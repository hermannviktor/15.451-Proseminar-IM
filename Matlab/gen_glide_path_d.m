function [glide_path] = gen_glide_path_d(ret_path, n, ret_e, ret_fi, infl)
%Generate dynamic glide path
%   Given realized return

avg_e = mean(ret_e);
% input here
mov_avg = 12;

table_rev = [-1, 0.6; ...
    -0.5, 0.4; ...
    0, 0.3; ...
    0.5, 0.2; ...
    1, 0];

for i = 1:size(ret_path,1)
    
    % generate 11 additional return
    row = randi(size(ret_e,1), [11, 1]);
    pre(:,1) = ret_e(row,1);
    pre(:,2) = ret_fi(row,1);
    pre(:,3) = infl(row,1);
    
    % constant allocation
    glide_path{i,1} = nan(n, 2);
    glide_path{i,1}(:,1) = 0.3;
    glide_path{i,1}(:,2) = 0.7;
     
    % mean reversion
    whole = [pre; ret_path{i,1}];
    
    roll_avg = movmean(whole(:,1), mov_avg);
    roll_avg = roll_avg(mov_avg/2+1:size(whole,1)-mov_avg/2+1,1);
    roll_std = movstd(whole(:,1), mov_avg);
    roll_std = roll_std(mov_avg/2+1:size(whole,1)-mov_avg/2+1,1);
    
    t_stat = (roll_avg - avg_e)./roll_std;
    
    t = sum(t_stat(1:end-1,1)>table_rev(:,1)',2);
    temp = nan(size(t));
    temp(t==0,1) = table_rev(1,2);
    temp(t==1,1) = table_rev(2,2);
    temp(t==2|t==3,1) = table_rev(3,2);
    temp(t==4,1) = table_rev(4,2);
    temp(t==5,1) = table_rev(5,2);
    
    glide_path{i,2} = nan(n, 2);
    glide_path{i,2}(1,1) = table_rev(3,2);
    glide_path{i,2}(2:end,1) = temp;
    glide_path{i,2}(:,2) = 1-glide_path{i,2}(:,1);
    
    % momentum  
    
    glide_path{i,3} = nan(n, 2);
    glide_path{i,3}(1,2) = 1-table_rev(3,2);
    glide_path{i,3}(2:end,2) = temp;
    glide_path{i,3}(:,1) = 1-glide_path{i,3}(:,2);
    
    %{
    % short term reversal
    t = sum(ret_path{i,1}(1:end-1,1)>table_rev(:,1)',2);
    temp = nan(size(t));
    temp(t==0,1) = table_rev(1,2);
    temp(t==1,1) = table_rev(2,2);
    temp(t==2|t==3,1) = table_rev(3,2);
    temp(t==4,1) = table_rev(4,2);
    temp(t==5,1) = table_rev(5,2);
    
    glide_path{i,2} = nan(n, 2);
    glide_path{i,2}(1,1) = table_rev(3,2);
    glide_path{i,2}(2:end,1) = temp;
    glide_path{i,2}(:,2) = 1-glide_path{i,2}(:,1);
    %}
end

end

