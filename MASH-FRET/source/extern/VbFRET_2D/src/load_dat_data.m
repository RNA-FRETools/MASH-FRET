function [dat err] = load_dat_data(filname, dat)

% This function parses .dat files that contain one or more raw FRET traces.
% Any lines of the file beginning with @ # $ % or & are treated as comments
% and are ignored. The first row of the file is used as labels. The first
% column of the data array is assumed to be cy3 data for trace 1. The
% second column is assumed to be cy5 data for trace 1. If there is a third 
% column it is assumed to be cy3 for trace 2, and so on.
%
% To be consistent with the HaMMy input file, the first column may also
% denote time steps (i.e. run from 1:T). If this is the case, the first
% column of the data is discarded and the second one is treated as cy3 and
% the 2nd one is treated as cy5. In addition, if only one trace is present
% in the .dat file then (consistent with HaMMy) the first row will be
% considered data an the label will be the title of the file.

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% initialize error flag
flag.type = 'importData';
[ignore,fileName,ext,ignore] = fileparts(filname);
flag.filname = [fileName ext];
err = 0; 

fid = fopen(filname);

if fid == -1
    flag.problem = 'read dat';
    vbFRETerrors(flag);
    err = 1;
    return
end

try
    % get size of file
    T = 0;
    readin = 0;
    while 1 
        readin = fgetl(fid);
        if readin == -1
            break
        end
        readin = strtrim(readin);
        
        if (isempty(readin) || readin(1) == '@' || readin(1) == '#' || readin(1) == '$' || readin(1) == '%' || readin(1) == '&')
            continue
        end

        % get number of data columns
        if T == 2
            C = length(str2num(readin));
        end

        T = T + 1;
    end

    % subtract the labels line if multiple traces present
    if C > 3
        T = T - 1;
    end
    
    % go back to beginning of file
    frewind(fid);

    % loop through .dat file 
    data = zeros(T,C); t = 0;
    labels = []; readin = 0;
    while 1 
        readin = fgetl(fid);
        if readin == -1
            break
        end
        readin = strtrim(readin);
        
        if (isempty(readin) || readin(1) == '@' || readin(1) == '#' || readin(1) == '$' || readin(1) == '%' || readin(1) == '&')
            continue
        end
        % load in first row as labels if more than one trace present
        if t == 0 
            if C > 3
                labels = regexp(readin, '\s+','split');
            else
                t = t+1;
                data(t,:) = str2num(readin);
            end
            t = t+1;
            continue
        end

        data(t,:) = str2num(readin);

        t = t+1;
    end
catch
    flag.problem = 'load data error';
    vbFRETerrors(flag);
    err = 1;
    return
end

if isempty(labels)
    labels = cell(1,2);
    labels{1} = fileName;
    % this will be delete later, added for simplicity of coding
    labels{2} = fileName;
end
    
N = size(data,2)/2;

% error if no data was loaded
if N/N ~= 1
    flag.problem = 'load data error';
    err = 1;
    vbFRETerrors(flag);
    return
end

% check to see if first column just contains time step numbers (i.e. dat
% has an odd number of columns and column 1 == 1:T)
if N ~= round(N)
    if ~isequal((data(1,1):data(end,1))',data(:,1))
        flag.problem = 'odd columns';
        err = 1;
        vbFRETerrors(flag);
        return
    end

    % if there was a label above the trace time steps, remove it
    if (length(labels)/2) == N
        labels(1) = [];
    end
    data(:,1) = [];
    N = size(data,2)/2;
end

% delete redundant labels
labels(2:2:end) = [];

if N ~= (length(labels))
    flag.problem = 'label length';
    vbFRETerrors(flag);
    labels = num2cell(1:N);
end

try
    % append traces in current file to existing traces
    for n=1:N
        cy3 = data(:,2*n-1);
        cy5 = data(:,2*n);
        label_n = num2str(labels{n});           
        
        q = length(dat.raw_bkup) + 1;

        % update backup traces
        dat.raw_bkup{q} = [cy3 cy5];
        dat.labels_bkup{q} = label_n;
        
        %update raw traces
        dat.raw{q} = dat.raw_bkup{q};
        dat.labels{q} = dat.labels_bkup{q};
        
        %update x_hat & z_hat
        dat.x_hat{1,q} = [];
        dat.x_hat{2,q} = [];
        dat.z_hat{q} = [];
    end
catch
    flag.problem = 'load data error';
    err = 1;
    vbFRETerrors(flag);
end