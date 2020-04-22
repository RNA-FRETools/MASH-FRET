function binTrajFiles(expT, varargin)
% binTrajFiles(expT)
% binTrajFiles(expT,pname)
% binTrajFiles(expT,pname,fileheaders)
% binTrajFiles(expT,pname,fileheaders,pname_out)
%
% Format MASH-processed trace files (*.txt) by binning data to a greater exposure time and writing data columns specified by headers.
%
% expT: desired time bin (in second)
% pname: source directory
% fileheaders: cellstring file headers that specify data to export
% pname_out: destination directory

% Last update, 10.4.2019 by MH: (1) adapt code to allow use without giving specific headers in input and to allow use with on sinlge input argument (the new time bin) (2) correct code for alex data (numbe of different laser was calculated from the number of time columns divided by 2)
% update: 18.2.2019 by MH: update help section

% cancelled by MH, 10.4.2019
% defaultHeaders = {'timeat638nm','I_1at638nm','I_2at638nm','I_3at638nm',...
%     'timeat532nm','I_1at532nm','I_2at532nm','I_3at532nm', 'FRET_1>2',...
%     'discr.FRET_1>2','S_Cy3','discr.S_Cy3'};

% added by MH, 10.4.2019
% collect source directory
if ~isempty(varargin) && numel(varargin)>=1
    pname = varargin{1};
    if isempty(pname) || ~sum(pname)
        disp('second input argument must contain the source directory');
        disp('for help type: help binTrajFiles');
        return
    end
    % added by MH, 10.4.2019
    % collect headers of column to export
    if numel(varargin)>=2
        headers = varargin{2};
        if isempty(headers)
            disp(cat(2,'third input argument must contain headers of file ',...
                'columns to export'));
            disp('for help type: help binTrajFiles');
            return
        end
        if numel(varargin)>=3
            pname_out = varargin{3};
            if ~strcmp(pname(end),filesep)
                pname_out = cat(2,pname_out,filesep);
            end
        else
            pname_out = pname;
        end
    else
        headers = {};
    end
else
    pname = uigetdir();
end
if isempty(pname) || ~sum(pname)
    return
end
cd(pname)

try
    % correct source directory
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end

    % get new exposure time
    binTime = expT;
    
    % cancelled by MH, 10.4.2019
%     % get final headers
%     if isempty(headers)
%         headFinal = headers;
%     else
%         headFinal = defaultHeaders;
%     end

    % list trajectory files in the folder
    fList = dir(cat(2,pname,'*.txt'));
    F = size(fList,1);

    % print file names in command window
    fprintf(cat(2,'\nprocess ',num2str(F),' files:\n'));
    for ff = 1:F
         fprintf(cat(2,'\t',fList(ff,1).name,'\n'));
    end

    % create output folder
    out_pname = cat(2,pname_out,'binned ',date,filesep);
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
        
        % added by MH, 10.4.2019
        if isempty(head{end})
            head = head(1:end-1);
        end
        
        % added by MH, 10.4.2019
        excid = strfind(head,'timeat');
        exc = [];
        for j = 1:numel(head)
            if ~isempty(excid{j})
                exc = [exc str2num(head{j}(length('timeat')+1:end-2))];
            end
        end
        exc = unique(exc);

        % localizes time data column from header
        isTime = cellfun('isempty',strfind(head,'timeat'));
        [o,timeIdref,o] = find(~isTime);
        
        % import data and bin according to time
        data = importdata(cat(2,pname,fList(ff,1).name));
        data = data.data;
        if exist('binTime','var')
            bin_1 = binTime*numel(exc); % multiple time bin for ALEX data
            bin_0 = data(2,timeIdref(1))-data(1,timeIdref(1)); % original bin time
            data = binData(data, bin_1*numel(exc), bin_0);
            if isempty(data)
                continue
            end
        end
        
        % order and remove columns
        % modified by MF, 10.4.2019
%         data = arrangeColumns(headFinal, head, data);
        if ~isempty(headers)
            headFinal = headers;
            data = arrangeColumns(headFinal, head, data);
        else
            headFinal = head;
        end

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
    if ~exist('ff','var')
        throw(err)
    end
    fprintf('\nError with file n°:%i, %s\n',ff,fList(ff,1).name);
    fprintf('%s\n', err.message);
    fprintf('in function: %s, line: %i\n', err.stack(1).name, ...
        err.stack(1).line);
    return
end

fprintf('\nprocess completed !\n');


function dataFinal = arrangeColumns(finalHead,originHead,data)

H = size(finalHead,2);
col = zeros(1,H);
for h = 1:H
    B = ~cellfun('isempty',strfind(originHead,finalHead{h}));
    B = find(B);
    col(h) = B(1);
end
dataFinal = data(:,col);
