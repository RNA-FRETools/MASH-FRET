function [dat err] = load_mat_data(filname, dat)

% This function parses .mat files that contain one or more raw FRET traces.
% The data must be stored as a cell array and the variable must
% be called 'data'. Labels may be stored as a separate array or cell array
% and the variable must be called 'labels'. If no variable called labels
% exists the data is labeled sequentially. The first
% column of the data array is assumed to be cy3 data for trace 1. The
% second column is assumed to be cy5 data for trace 1. If there is a third 
% column it is assumed to be cy3 for trace 2, and so on.

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% initialize error flag
flag.type = 'importData';
[ignore,fileName,ext,ignore] = fileparts(filname);
flag.filname = [fileName ext];
err = 0; 

% get info about data stored in .mat
mat_vars = who('-file',filname);

% error if no variable called 'data'
if isempty(strmatch('data',mat_vars,'exact'))
    flag.problem = 'no data';
    vbFRETerrors(flag);
    err = 1;
    return
end

% load data
load(filname,'data')

% determine number of traces present
if iscell(data)
    N = length(data);
else
    flag.problem = 'not cell';
    vbFRETerrors(flag);
    err = 1;
    return
end

% get data labels if there's a variable called labels
if ~isempty(strmatch('labels',mat_vars,'exact'))
    load(filname,'labels')
    
    % check that num labels = num traces    
    num_labels = length(labels);
    
    if ~iscell(labels)
        labels = num2cell(labels);
    end
    
    if N ~= num_labels
        flag.problem = 'label length';
        vbFRETerrors(flag);
        labels = num2cell(1:N);
    end   
else
    labels = num2cell(1:N);
end

% get path data if there's a variable called path, no error checking - the
% user has to be competent this time
if ~isempty(strmatch('path',mat_vars,'exact'))
    load(filname,'path')
else
    path = [];
end

try
    % append traces in current file to existing traces
    for n=1:N
        % flip trace if it's inverted
        [L W] = size(data{n});
        if L == 2 && W ~= 2
            data{n} = data{n}';
        end        
        cy3 = data{n}(:,1);
        cy5 = data{n}(:,2);
        label_n = num2str(labels{n});           
        
        % append traces in current file to existing traces
        q = length(dat.raw_bkup) + 1;

        % update backup traces
        dat.raw_bkup{q} = [cy3 cy5];
        dat.labels_bkup{q} = label_n;
        
        %update raw traces
        dat.raw{q} = dat.raw_bkup{q};
        dat.labels{q} = dat.labels_bkup{q};
        
        %update x_hat & z_hat
        if length(path) < n
            dat.x_hat{1,q} = [];
            dat.x_hat{2,q} = [];
            dat.z_hat{q} = [];
        else
            xhat = path{n};
            % infer z_hat from x_hat
            zhat = xhat;
            xunique = unique(xhat);
            for i = 1:length(xunique)
                zhat(zhat == xunique(i)) = i;
            end
            % generate 2D x_hat
            xhat_2D = x_hat_2D(zhat,dat.raw{q});

            %update x_hat & z_hat
            dat.x_hat{1,q} = xhat;
            dat.x_hat{2,q} = xhat_2D;
            dat.z_hat{q} = zhat;
        end
    end
catch 
    flag.problem = 'load data error';
    err = 1;
    vbFRETerrors(flag);
end