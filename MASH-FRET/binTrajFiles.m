function binTrajFiles(varargin)
% Restructure the trajectories files (*.txt) by binning time data to a
% greater exposure time and reordering the columns according to user
%
% binTrajFiles('C:\Users\SigelPC18\Documents\MATLAB\Susi data\SP_09\traces_processing\traces_ASCII', 0.1)

try
    % get and correct folder path
    if isempty(varargin)
        pname = cat(2,uigetdir('','Select folder'),filesep);
    else
        pname = varargin{1};
    end
    if ~sum(pname)
        return;
    end
    if ~strcmp(pname(end),'\')
        pname = [pname,filesep];
    end

    % get new binning time
    if size(varargin,2)>=2
        binTime = varargin{2};
    end
    
    % get final headers
    if size(varargin,2)>=3
        headFinal = varargin{3};
    else
        headFinal = {'timeat638nm','I_1at638nm','I_2at638nm', ...
            'I_3at638nm', 'timeat532nm','I_1at532nm','I_2at532nm', ...
            'I_3at532nm', 'FRET_1>2','discr.FRET_1>2','S_Cy3', ...
            'discr.S_Cy3'};
    end

    % list trajectory files in the folder
    fList = dir(cat(2,pname,'*.txt'));
    F = size(fList,1);

    % print file names in command window
    fprintf(cat(2,'\nprocess ',num2str(F),' files:\n'));
    for ff = 1:F
         fprintf(cat(2,'\t',fList(ff,1).name,'\n'));
    end

    % create output folder
    out_pname = cat(2,pname,'binned ',date,filesep);
    if ~exist(out_pname,'dir')
        mkdir(out_pname);
    end

    % process files
    for ff = 1:F
        % get file header line
        f = fopen(cat(2,pname,filesep,fList(ff,1).name),'r');
        headline = fgetl(f);
        fclose(f);

        % get tab-separated headers
        idt = [1-length(sprintf('\t')),strfind(headline,sprintf('\t'))];
        nCol = size(idt,2);
        head = cell(1,nCol);
        for ii = 1:nCol-1
            head{ii} = headline((idt(ii)+length(sprintf('\t'))): ...
                (idt(ii+1)-length(sprintf('\t'))));
            head{ii}(head{ii}==' ') = [];
        end
        head{end} = headline((idt(nCol)+length(sprintf('\t'))): ...
            (length(headline)-length(sprintf('\n'))+1));

        % localizes time data column from header
        isTime = cellfun('isempty',strfind(head,'timeat'));
        [o,timeIdref,o] = find(~isTime);
        
        % import data and bin according to time
        data = importdata(cat(2,pname,fList(ff,1).name));
        data = data.data;
        if exist('binTime','var')
            data = binData(data, binTime, timeIdref);
        end
        
        % order and remove columns
        data = arrangeColumns(headFinal, head, data);

        % export binned trajectory
        nCol2 = size(headFinal,2);
        if ff==1
            headStr = [];
            for ii = 1:nCol2-1
                headStr = cat(2,headStr,headFinal{ii},'\t');
            end
            headStr = cat(2,headStr,headFinal{nCol2},'\n');
        end
        
        [o,fname,fext] = fileparts(fList(ff,1).name);
        fname_out = sprintf('%s_bin_%f.txt',fname,binTime);
        
        f = fopen(cat(2,out_pname,filesep,fname_out),'Wt');
        fprintf(f,headStr);
        fprintf(f,cat(2,repmat('%d\t',1,nCol2-1),'%d\n'),data');
        fclose(f);
        
    end

catch err
    fprintf('\nError with file n°:%i, %s\n',ff,fList(ff,1).name);
    fprintf('%s\n', err.message);
    fprintf('in function: %s, line: %i\n', err.stack(1).name, ...
        err.stack(1).line);
    return;
end

fprintf('\nprocess completed !\n');


function binned = binData(data, bin_1, colTime)

binned = data;

bin_1 = bin_1*numel(colTime)/2; % multiple time bin for ALEX data
bin_0 = data(2,colTime(1))-data(1,colTime(1)); % original bin time
if bin_0>bin_1
    fprintf(['\nTime binning failed: exposure time in data is larger ' ...
        'than the input time binning.\n']);
    return;
end
bin_l = bin_1/bin_0;
L_0 = size(data,1);
L_1 = fix(L_0/bin_l);

binned = NaN(L_1,size(data,2));
l_1 = 1;
curs = 0;
while l_1<=L_1
    % determine l_0 from cursor position
    l_0 = ceil(curs);
    if l_0 == 0
        l_0 = 1;
    end
    
    % remaining fraction of l_0 to consider for calculation
    rest_0 = 1-mod(curs,1);
    
    % add remaining fraction of l_0 in current l_1
    binned(l_1,:) = rest_0*data(l_0,:);
    
    % remaining frames to add to l_1 to complete a bin
    bin_rest = bin_l-rest_0;
    
    % add full l_0 bins to l_1
    if l_0+fix(bin_rest)<= L_0
        binned(l_1,:) = binned(l_1,:) + ...
            sum(data(l_0+1:l_0+fix(bin_rest),:),1);
    else
        binned = binned(1:l_1-1,:);
        return;
    end
    
    % add rest l_0 bins to l_1
    if l_0+fix(bin_rest)+1<= L_0
        binned(l_1,:) = binned(l_1,:) + ...
            (bin_rest-fix(bin_rest))*data(l_0+fix(bin_rest)+1,:);
    else
        binned = binned(1:l_1-1,:);
        return;
    end
    
    % averaging
    binned(l_1,:) = binned(l_1,:)/bin_l;
    
    % advance cursor in orginial trajectory of one bin and l_1 of one frame
    curs = curs + bin_l;
    l_1 = l_1 + 1;
end

function dataFinal = arrangeColumns(finalHead,originHead,data)

H = size(finalHead,2);
col = zeros(1,H);
for h = 1:H
    B = ~cellfun('isempty',strfind(originHead,finalHead{h}));
    B = find(B);
    col(h) = B(1);
end
dataFinal = data(:,col);
