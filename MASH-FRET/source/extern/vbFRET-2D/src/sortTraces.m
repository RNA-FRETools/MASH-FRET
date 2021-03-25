function [dat] = sortTraces(dat,n0,N)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% this function arranges the traces in numerical/alphabetical order. if 2
% traces have the same label it generates a warning.
format short g;

% sort strings and numbers separately

% don't sort traces loaded from before
prev_traces_idx = zeros(1,n0-1);
% holds the names/indexes of string based labels
str_traces = cell(1,N);
str_traces_idx = zeros(1,N);
% holds the names/indexes of number based labels
num_traces = zeros(1,N);
num_traces_idx = zeros(1,N);

for n=1:N
    if n < n0
        prev_traces_idx(n) = n;
    else
        % check to see if the label is numeric or a string
        num = str2num(dat.labels_bkup{n});
        % if it is a string
        if isempty(num)
            str_traces{n} = dat.labels_bkup{n};
            str_traces_idx(n) = n;
        % if it is a number
        else        
            num_traces(n) = num;
            num_traces_idx(n) = n;
        end
    end
end

%remove empty cells
del = find(str_traces_idx == 0);
str_traces(del) = [];
str_traces_idx(del) = [];
del = find(num_traces_idx == 0);
num_traces(del) = [];
num_traces_idx(del) = [];

% alphabetize
[ig str_sort_order] = sort(str_traces);
[ig num_sort_order] = sort(num_traces);

% reorder the traces in the order of sorted_order
sorted_order = [prev_traces_idx num_traces_idx(num_sort_order) str_traces_idx(str_sort_order)];

% sort
dat.labels_bkup = dat.labels_bkup(sorted_order);
dat.labels = dat.labels(sorted_order);
dat.raw_bkup = dat.raw_bkup(sorted_order);
dat.raw = dat.raw(sorted_order);
dat.x_hat = dat.x_hat(:,sorted_order);
dat.z_hat = dat.z_hat(sorted_order);

%check for redundant labels
if length(dat.labels_bkup) ~= length(unique(dat.labels_bkup))
    flag.type = 'importData';
    flag.problem = 'unique traces';
    vbFRETerrors(flag);
end