function [coverage_ratio] = coverage(wealth, consumption, n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

a = sum(wealth>0)/n;

if a < 1
    coverage_ratio = a;
else
    add = wealth(end,1)/consumption;
    coverage_ratio = a+add/n;
end

end

