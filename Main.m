%% Proseminar

cd('C:\Users\CF\Desktop\MIT\Fall 2018\Proseminar in Capital Markets and Investment Management');
addpath('./Code'); 

clear;
clear all;

%% Input
y = 30; % years in retirement
n = y*12;
x = 0.2; % amount taken out per period
e = 100000; % endowment
w = 10; % years for separating sequence risk
m = 200000; % number of return paths

%% Read Data
[date, ret_e, ret_fi, infl] = import_data(); 
infl_avg = mean(infl);

%% Generate Return Paths

% bootstrap
for i=1:m
    ret_path{i,1} = gen_ret_path(ret_e, ret_fi, n);
end

%% Set Glide Path
% possible input here
glide_path = gen_glide_path(n);

%% Simulate
[wealth, consumption, ret_tot] = simulate(ret_path,glide_path, x, e, n, infl_avg);

%% Performance Measures
% coverage ratio
% first column sorr, second column coverage

%{
for i = 1:size(glide_path,1)
    for j = 1:size(ret_path,1)
        % diff weight for SORR
        ratio{i,1}(j,1) = sorr(ret_tot{j,i}, w, n);
        ratio{i,1}(j,2) = sum((wealth{j,i}>0))/n;
    end
    ratio{i,1}(:,3) = ratio{i,1}(:,2)./ratio{i,1}(:,1);
    ratio_tot(i,1) = mean(ratio{i,1}(:,3));
end
%}

for i = 1:size(ret_path,1)
    ratio(i,1) = sorr(ret_path{i,1}(:,1), w, n);
    for j = 1:size(glide_path,1)
        % diff weight for SORR
        ratio(i,j+1) = sum((wealth{i,j}>0))/n;
    end
end

[ratio_plot(:,1), ~, ind] = unique(ratio(:,1));
ratio_plot(:,2) = accumarray(ind, ratio(:,2), [], @mean);
ratio_plot(:,3) = accumarray(ind, ratio(:,3), [], @mean);
ratio_plot(:,4) = accumarray(ind, ratio(:,4), [], @mean);

% utility function

%% Plot

figure(1);

plot(ratio_plot(:,1), ratio_plot(:,2), ...
    ratio_plot(:,1), ratio_plot(:,3), ...
    ratio_plot(:,1), ratio_plot(:,4));
title('Coverage ratio and sorr');
legend('Normal', 'Conservative', 'Aggressive');

% take out outliers
%{
for f = 1:size(glide_path,1)
    ratio{f,1}(find(abs(ratio{f,1}(:,1))>10),:) = [];  
    ratio{f,1}(find(ratio{f,1}(:,1)<0),:) = [];  
end

figure(1);
num = 1;

for f = 1:size(glide_path,1)
    subplot(num,size(glide_path,1)/num,f);
    scatter(ratio{f,1}(:,1), ratio{f,1}(:,2));
end

%figure(2);
%bar(ratio_tot);
%}

%% Next Steps
%{
1. Fixed-income data - Ellie
Longer time series
How to calculate monthly fixed-income returns 
Risk free index
2. Create notes in PPT about assumptions - Viktor
3. Define SORR - Ellie Rachel Jonathan
Think of how to best SORR
Possibly 3 SORR measures
e.g. simple average, decreasing weight average
? -> SORR -> (input) strategy -> (using historical data) max ?
4. Code other stuff - Chen

%}

