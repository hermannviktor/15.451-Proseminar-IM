function [output] = gen_ret_path_sorr(ret_e, ret_fi, infl, n, sorri, w)
%Generate paths of returns of certain sorr
%   Paths where good returns happen first, bad returns first and average

%row = randi(size(ret_e,1), [n, 1]);
row = randperm(size(ret_e,1), n)';

path(:,1) = ret_e(row,1);
path(:,2) = ret_fi(row,1);
path(:,3) = infl(row,1);

b = 0.3;
[~, ind] = sort(path(:,1), 'ascend');
t = n*b; 
c = ind(1:t,1);
c2 = ind(t+1:n,1);
bot_ret = path(c,:);
top_ret = path(c2,:);

bot_num = round(t*sorri);
bot_row = randperm(size(bot_ret,1), bot_num)';
[~, ind1] = ismember((1:size(bot_ret,1))', bot_row);
ind1 = ind1>0;
top_num = w*12-bot_num;
top_row = randperm(size(top_ret,1), top_num)';
[~, ind2] = ismember((1:size(top_ret))', top_row);
ind2 = ind2>0;

first_path = bot_ret(ind1,:);
first_path = [first_path; top_ret(ind2,:)];
last_path = bot_ret(~ind1,:);
last_path = [last_path; top_ret(~ind2,:)];

first_path_af = first_path(randperm(size(first_path,1))',:);
last_path_af = last_path(randperm(size(last_path,1))',:);

output = [first_path_af; last_path_af];

end

