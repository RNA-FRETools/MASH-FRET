function restruct_trace_file(varargin)
% Restructure the trajectories files (*.txt) into a format that is
% importable into MASH
% If ALEX is used, trajecories recorded upon different excitation are saved
% into one column, alternating the data linewise

if isempty(varargin)
    pname = cat(2,uigetdir('','Select folder'),filesep);
else
    pname = varargin{1};
end

if ~strcmp(pname(end),'\')
    pname = [pname,filesep];
end

DONOR_EXC = 532;

fList = dir(cat(2,pname,'*.txt'));
F = size(fList,1);
allHead = {};
headPos = [];

% print file list
fprintf(cat(2,'\nprocess ',num2str(F),' files:\n'));
for ff = 1:F
     fprintf(cat(2,'\t',fList(ff,1).name,'\n'));
end

units = repmat({'None'}, 1,F);  % added by FS, 15.11.18
% collect all headers
for ff = 1:F
    f = fopen(cat(2,pname,filesep,fList(ff,1).name),'r');
    headline = fgetl(f);
    fclose(f);
    
    % detect tabulation characters
    idt = [1-length(sprintf('\t')),strfind(headline,sprintf('\t'))];
    nCol = size(idt,2);
    head = {};
    
    % extract separated column headers
    for ii = 1:nCol-1
        head = [head,headline((idt(ii)+length(sprintf('\t'))): ...
            (idt(ii+1)-length(sprintf('\t'))))];
        head{size(head,2)}(head{size(head,2)}==' ') = [];
    end
    head = [head,headline((idt(nCol)+length(sprintf('\t'))): ...
        (length(headline)-length(sprintf('\n'))+1))];
    
    % add to header list with column number if not already in
    for ii = 1:size(head,2)
        
        % added by FS, 15.11.18
        u = extractBetween(head{ii},'(',')');
        if ~isempty(u)
            units{ff} = u;
        end
        head{ii} = regexprep(head{ii},'\(\w+\)','');
        
        isnotfound = cellfun('isempty',strfind(allHead,head{ii}));
        if sum(isnotfound)==size(allHead,2)
            allHead =[allHead,head{ii}];
            headPos = cat(2,headPos,zeros(F,1));
            headPos(ff,size(allHead,2)) = ii;
        else
            id = find(~isnotfound,1);
            headPos(ff,id(1)) = ii;
        end
    end
end

excl = sum(~~headPos,1)<F;
headPos(:,excl) = [];
allHead(excl) = [];
% remove discretized intensities
excl = contains(allHead,'discr.I');
allHead(excl) = [];
headPos(:,excl) = [];

if isempty(headPos)
    fprintf('\nNo Common column found. Process aborted.\n');
end

out_pname = cat(2,pname,'restructured ',date,filesep);
if ~exist(out_pname,'dir')
    mkdir(out_pname);
end

nCol = size(allHead,2);

% determine time column indexes
isTime = cellfun('isempty',strfind(allHead,'timeat'));
[o,timeIdref,o] = find(~isTime);

% determine corresponding wavelength exc.
nExc = numel(timeIdref);
exc = zeros(1,nExc);
for l = 1:nExc
    pos = strfind(allHead{timeIdref(l)},'nm');
    exc(l) = str2num(allHead{timeIdref(l)}(length('timeat')+1:pos-1));
end

for ff = 1:F
    try
        
        % import and rearrange data according to reference
        data = importdata(cat(2,pname,fList(ff,1).name));
        data = data.data;
        data = data(:,headPos(ff,headPos(ff,:)<=size(data,2)));
        id_sup = find(headPos(ff,:)>size(data,2));
        
        if ~isempty(id_sup)
            data = [data, nan(size(data,1),numel(id_sup))];
        end
        
        L = size(data,1);
        
        isFrame = double(~~sum(~cellfun('isempty', ...
            strfind(allHead,'frame'))));

        % if the first excitation is different from the reference, switch time
        % data allowing similar ALEX sequence as reference
        [o,timeId] = sort(data(1,timeIdref),'ascend');
        if ~isequal(timeId,1:nExc)
            data(:,timeIdref) = data(:,timeIdref(timeId));
            allHead(timeIdref) = allHead(timeIdref(timeId));
            if isFrame
                data(:,timeIdref+1) = data(:,timeIdref(timeId)+1);
                allHead(timeIdref+1) = allHead(timeIdref(timeId)+1);
            end
        end

        % determine the number of channel by counting occurences of pattern 
        % 'I_' in hearderline
        nChan = sum(~cellfun('isempty',strfind(allHead,'I_')))/nExc;

        rmHead = false(1,nCol);
        
        % organize intensity data row-wise regarding excitation
        alexData = NaN(nExc*L,nChan+1+isFrame);
        for ii = 1:nCol
            % identify excitation for each column
            for l = 1:nExc
                isExc =  strfind(allHead{ii},num2str(exc(l)));
                if ~isempty(isExc)
                    break;
                end
            end

            if isempty(isExc) % FRET, FRET_discr, S or S_discr
                alexData = cat(2,alexData,NaN(L*nExc,1));
                alexData(find(exc==DONOR_EXC):nExc:end,end) = data(:,ii);
            else
                if ii>1+isFrame+nChan % second excitation
                    id = ii-1-isFrame-nChan;
                    rmHead(ii) = true;
                else
                    id = ii;
                end
                alexData(l:nExc:end,id) = data(:,ii);
            end
        end

        allHead2 = allHead(:,~rmHead);
        nCol2 = size(allHead2,2);

        if ff==1
            headStr = [];
            for ii = 1:nCol2-1
                headStr = cat(2,headStr,allHead2{ii},'\t');
            end
            headStr = cat(2,headStr,allHead2{nCol2},'\n');
        end
        
        % added by FS, 15.11.18
        headStr2 = strsplit(headStr, '\\t');
        headStr = [];
        for ii = 1:size(headStr2,2)
            if ~isempty(strfind(headStr2{ii},'I_'))
                if ~strcmp(units{ff}, 'None')
                    headStr2{ii} = strcat(headStr2{ii},'(',units{ff}{:},')');  % added by FS,15.11.2018
                else
                    headStr2{ii} = regexprep(headStr2{ii},'\(\w+\)','');  % added by FS,15.11.2018
                end
            end
            headStr = cat(2,headStr,headStr2{ii},'\t');
        end
        headStr = headStr(1:end-2);

        f = fopen(cat(2,out_pname,filesep,fList(ff,1).name),'Wt');
        fprintf(f,headStr);
        fprintf(f,cat(2,repmat('%d\t',1,nCol2-1),'%d\n'),alexData');
        fclose(f);
        
    catch err
        fprintf('\nError with file n°:%i, %s\n',ff,fList(ff,1).name);
        fprintf('%s\n', err.message);
        fprintf('in function: %s, line: %i\n', err.stack(1).name, ...
            err.stack(1).line);
        return;
    end
end

fprintf('\nprocess completed !\n');



