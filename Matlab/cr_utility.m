function [uti] = cr_utility(ratio, gamma, lambda)
%Calculate utility based on coverage ratio
%   Kinked utility function

if ratio >= 1
    uti = (ratio^(1-gamma)-1)/(1-gamma);
else
    uti = (1^(1-gamma)-1)/(1-gamma)-lambda*(1-ratio);
end 

end

