function [glide_path] = gen_glide_path(ret_path, n)
%Generate different glide path
%   Average, conservative and aggressive asset allocation

% first column: equity allocation
% second column: fixed income allocation

% first part: all constant
% second: changing over time
% more assumptions later
for i = 1:size(ret_path,1)    
    glide_path{i,1} = nan(n, 2);
    glide_path{i,1}(:,1) = 0.3;
    glide_path{i,1}(:,2) = 0.7;

    a = 0.35;
    b = 0.64;
    c = (b-a)/(n-1);
    glide_path{i,2} = nan(n, 2);
    glide_path{i,2}(:,1) = (a:c:b)';
    glide_path{i,2}(:,2) = 1-glide_path{1,2}(:,1);

    glide_path{i,3} = nan(n, 2);
    glide_path{i,3}(:,1) = (b:-c:a)';
    glide_path{i,3}(:,2) = 1-glide_path{1,3}(:,1);

end

end

