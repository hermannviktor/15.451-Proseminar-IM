function [date, ret_e, ret_fi, infl] = import_data()
%Import data
%   Read excel file

addpath('./Data'); 
[data, ~] = xlsread('data.xlsx', 'data');

data(2:end,2) = data(2:end,2)./data(1:end-1,2)-1;
price = 1/(1+data(1:end,3)/100);
data(2:end,3) = data(2:end,3)./data(1:end-1,3)-1;
%data(2:end,3) = data(1:end-1,3)/100;
data(2:end,4) = data(2:end,4)./data(1:end-1,4)-1;
data(sum(isnan(data),2)>0,:) = [];

date = x2mdate(data(:,1));
ret_e = data(:,2);
ret_fi = data(:,3);
infl = data(:,4);

end

