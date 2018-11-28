function [date, ret_e, ret_fi, infl] = import_data()
%Import data
%   Read excel file

addpath('./Data'); 
[data, txt] = xlsread('Monthly_returns.xlsx');

date = datenum(txt(2:end,1), 'yyyy-mm');
ret_e = data(:,1);
ret_fi = data(:,2);
infl = data(:,3);

end

