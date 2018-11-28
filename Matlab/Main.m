%% Proseminar

cd('C:\Users\CF\Desktop\MIT\Fall 2018\Proseminar in Capital Markets and Investment Management');
addpath('./Code'); 

clear;
clear all;
clc;
tic;

%% Input
y = 30; % years in retirement
n = y*12;
x = 0.04; % amount taken out per period
e = 1000000; % endowment
w = 10; % years for separating sequence risk
m = 1000; % number of return paths
gamma = 0.99; 
lambda = 10; % slope of utility function
d = 1; %dynamic toggle: 0 - static, 1 - dynamic
s = 1; %sorr toggle: 0 - randomly generate, 1 - generate path of sorr

%% Read Data
disp('Reading data...');
[date, ret_e, ret_fi, infl] = import_data(); 
infl_avg = mean(infl);

%% Generate Return Paths
disp('Generating return paths...');
% bootstrap

if s == 0
    for i=1:m
        ret_path{i,1} = gen_ret_path(ret_e, ret_fi, infl, n);
    end
else
    for so = 0:10
        sorri = so/10;
        for i = 1:m
            ret_path{so*m+i,1} = gen_ret_path_sorr(ret_e, ret_fi, infl, n, sorri, w);
        end
    end
end

%% Set Glide Path
disp('Setting glide paths...');
if d == 0
    glide_path = gen_glide_path(ret_path, n);
else
    glide_path = gen_glide_path_d(ret_path, n, ret_e, ret_fi, infl);
end

%% Simulate
disp('Simulating returns and consumption...');
if d == 0
    [wealth, consumption, ret_tot] = simulate(ret_path,glide_path, x, e, n);
else
    [wealth, consumption, ret_tot] = simulate_d(ret_path,glide_path, x, e, n);
end

%% Performance Measures
disp('Calculating performance metrics...');
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
    utility(i,1) = ratio(i,1);
    for j = 1:size(glide_path,2)
        % diff weight for SORR
        ratio(i,j+1) = coverage(wealth{i,j}, consumption{i,1}(end,1), n);
        utility(i,j+1) = cr_utility(ratio(i,j+1),gamma,lambda);
    end
end

[ratio_plot(:,1), ~, ind] = unique(ratio(:,1));
ratio_plot(:,2) = accumarray(ind, ratio(:,2), [], @mean);
ratio_plot(:,3) = accumarray(ind, ratio(:,3), [], @mean);
ratio_plot(:,4) = accumarray(ind, ratio(:,4), [], @mean);

[utility_plot(:,1), ~, ind] = unique(utility(:,1));
utility_plot(:,2) = accumarray(ind, utility(:,2), [], @mean);
utility_plot(:,3) = accumarray(ind, utility(:,3), [], @mean);
utility_plot(:,4) = accumarray(ind, utility(:,4), [], @mean);

%% Plot

% line graph

figure(1);

subplot(1,2,1);
plot(ratio_plot(:,1), ratio_plot(:,2), ...
    ratio_plot(:,1), ratio_plot(:,3), ...
    ratio_plot(:,1), ratio_plot(:,4));
title('Coverage ratio and sorr');
if d == 0
    legend('Normal', 'Conservative', 'Aggressive');
else
    legend('Normal', 'Mean reversion', 'Momentum');
end

subplot(1,2,2);
plot(utility_plot(:,1), utility_plot(:,2), ...
    utility_plot(:,1), utility_plot(:,3), ...
    utility_plot(:,1), utility_plot(:,4));
title('Utility and sorr');
if d == 0
    legend('Normal', 'Conservative', 'Aggressive');
else
    legend('Normal', 'Mean reversion', 'Momentum');
end

% histogram

figure(2);

sorr_plot = [0.3; 0.5; 0.7];
if d == 0
    glide_path_name = {'Normal'; 'Conservative'; 'Aggressive'};
else
    glide_path_name = {'Normal';'Mean reversion';'Momentum'};
end

for i = 1:size(sorr_plot,1)
    sorr_round = round(utility(:,1),1);
    sel = utility(find(sorr_round == sorr_plot(i)),:);
    for j = 1:size(glide_path,2)
        subplot(3,3,(i-1)*3+j);
        %histogram(sel(:,j+1), 'BinLimits',[-6,0], 'BinWidth', 0.1);
        histogram(sel(:,j+1));
        title(['SORR ', num2str(sorr_plot(i)), ': ', glide_path_name{j}]);
    end
end




disp('Done');
toc;


%% Next Steps

%{
clear test_uti
test = (0:0.01:5)';
for i = 1:size(test,1)
    test_uti(i,1) = cr_utility(test(i,1), gamma, lambda);
end
figure(3);
plot(test, test_uti);
%}
