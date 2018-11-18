function [glide_path] = gen_glide_path(n)
%Generate different glide path
%   Average, conservative and aggressive asset allocation

% first column: equity allocation
% second column: fixed income allocation

% first part: all constant
% second: changing over time
% more assumptions later

glide_path{1,1} = nan(n, 2);
glide_path{1,1}(:,1) = 0.3;
glide_path{1,1}(:,2) = 0.7;

a = 0.3;
b = 1-a;
c = (b-a)/(n-1);
glide_path{2,1} = nan(n, 2);
glide_path{2,1}(:,1) = (a:c:b)';
glide_path{2,1}(:,2) = (b:-c:a)';

glide_path{3,1} = nan(n, 2);
glide_path{3,1}(:,1) = (b:-c:a)';
glide_path{3,1}(:,2) = (a:c:b)';

end

