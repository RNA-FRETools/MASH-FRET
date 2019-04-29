function restruct_trace_file(varargin)
% | Format trajectories files (*.txt) to MASH-importable structure.
% |
% | command: restruct_trace_file(pname);
% | 1st argument (optional) >> source directory
% | 2nd argument (optional) >> 1-by-(nFRET+nS) laser wavelengths for 
% |             donor- and emitter-specific illuminations used in FRET and 
% |             stoichiometry calculations.
% |             example: if files contain columns for FRET_Cy3>Cy5, 
% |             discrFRET_Cy3>Cy5, FRET_Cy5>Cy7, discrFRET_Cy5>Cy7,
% |             S_Cy3, discrS_Cy3, S_Cy5, and discrS_Cy5
% |             in order of appearence, RATIO_EXC = [532 532 638 638 532 
% |             532 638 638]
% |
% | example: restruct_trace_file('C:\MyDataFolder\experiment_01\traces_processing\traces_ASCII\');

% Last update: 10th of April 2019 by Mélodie Hadzic
% --> implement GUI-based user input to select source directory, choose 
%     file format (Trace processing/Transition analysis import) and
%     ratio-specific illumination wavelength
%
% update: 3rd of April 2019 by Mélodie Hadzic
% --> implement restructuration of files with multiple FRET and 
%     stoichiometry and write substitute to MATLAB built-in function
%     extractBetween for version older than 2016b
%
% update: 18th of February 2019 by Mélodie Hadzic
% --> update help section

% added by MH, 10.4.2019
% get source directory
if ~isempty(varargin) && numel(varargin)>=1
    pname = varargin{1};
else
    pname = uigetdir('','Select the source directory');
    if isempty(pname) || ~sum(pname)
        return;
    end
end

if ~strcmp(pname(end),'\')
    pname = cat(2,pname,filesep);
end

% added by MH, 10.4.2019
cd(pname);

% modified by MH, 10.4.2019
% get ratio-specific illuminations
% if ~isempty(varargin)
%     DONOR_EXC = varargin{1};
% else
%     DONOR_EXC = 532;
% end
if ~isempty(varargin) && numel(varargin)>=2
    RATIO_EXC = varargin{2};
else
    RATIO_EXC = [];
end

% added by MH, 10.4.2019
% activate/deactivate reorganization of ratio data
if isempty(RATIO_EXC)
    % ask user the new format of restructured files
    module = questdlg({cat(2,'How do you want to format restructured trace ',...
        'files?'),'- for Trace processing: restructure intensity data only',...
        '- for Transition analysis / other: restructure all'},...
        'Chose a file format','for Trace processing',...
        'for Transition analysis / other','Cancel',...
        'for Trace processing');
    if strcmp(module,'for Trace processing')
        reorgRatio = false;
    elseif strcmp(module,'for Transition analysis / other')
        reorgRatio = true;
    else
        return;
    end
else
    reorgRatio = true;
end

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
        % modified by MH, 3.4.2019
%         u = extractBetween(head{ii},'(',')');
        u = regexp(head{ii},'\(\w*\)','match');
        if ~isempty(u)
            u = u(2:end-1);
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

% modified by MH, 3.4.2019
% excl = contains(allHead,'discr.I');
excl = strfind(allHead,'discr.I');
excl = ~cellfun('isempty',excl);

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

% added by MH, 10.4.2019
% if not defined in input argument, aske for ratio-specific illuminations
if reorgRatio && isempty(RATIO_EXC)
    ratioHead = {};
    for ii = 1:nCol
        % identify excitation for each column
        for l = 1:nExc
            isExc =  strfind(allHead{ii},num2str(exc(l)));
            if ~isempty(isExc)
                break;
            end
        end
        if isempty(isExc)
            ratioHead = [ratioHead allHead{ii}];
        end
    end
    fig = inputlaserdlg(ratioHead,'Ratio-specific illumination',exc);
    waitfor(fig,'userdata');
    if ishandle(fig)
        RATIO_EXC = get(fig,'userdata');
        close(fig);
        if numel(RATIO_EXC)==1 && RATIO_EXC==0
            return;
        end
    else
        return;
    end
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
        
        % added by MH, 3.4.2019
        % initilize counter for non-intensity columns
        j = 0;
        
        for ii = 1:nCol
            % identify excitation for each column
            for l = 1:nExc
                isExc =  strfind(allHead{ii},num2str(exc(l)));
                if ~isempty(isExc)
                    break;
                end
            end
            
            % If ALEX is used, data are alternated row-wise.

            % modified by MH, 10.4.2019
%             if isempty(isExc) % FRET, FRET_discr, S or S_discr
            % include ratio data in restructured file at proper excitations
            if reorgRatio && isempty(isExc) % FRET, FRET_discr, S or S_discr

                alexData = cat(2,alexData,NaN(L*nExc,1));

                % modified by MH, 3.4.2019
%                 alexData(find(exc==RATIO_EXC):nExc:end,end) = data(:,ii);
                j = j+1;
                if j>size(RATIO_EXC,2)
                    disp(cat(2,'the number of non-intensity columns ',...
                        'in file ',fList(ff,1).name,'is greater than ',...
                        'second input argument size: please review ',...
                        'the second input argument'));
                    return;
                end
                alexData(find(exc==RATIO_EXC(j)):nExc:end,end) = ...
                    data(:,ii);
                
            % added by MH, 10.4.2019
            % exclude ratio data from restructured file
            elseif isempty(isExc)
                rmHead(ii) = true;
                
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


% added by MH, 10.4.2019
function fig = inputlaserdlg(dlgtxt,dlgtitle,exc)
% builds a figure to get user inputs on ratio-specific illuminations and
% return the figure handle.
% dlgtxt >> {1-by-R} cellstring with ratio data labels (column headers)
% dlgtitle >> string, figure title
% exc >> [1-by-nExc], laser wavelength

% get dimensions
R = numel(dlgtxt);
h_pop = 20;
w_pop = 80;
h_but = 20;
w_but = 40;
h_text = 14;
h_intro = h_text*5;
mg = 10;
halfSize = ceil(R/2);
if R==1
    nCol = 1;
else
    nCol = 2;
end
h_fig = mg + h_intro + mg + halfSize*(h_text+h_pop+mg) + h_but + mg;
w_fig = mg + nCol*(w_pop+mg);
w_intro = w_fig - mg;

% get popupmenu string
str_pop = {};
for l = 1:numel(exc)
    str_pop = [str_pop,cat(2,num2str(exc(l)),'nm')];
end

% build figure
fig = figure('name',dlgtitle,'numbertitle','off','menubar','none',...
    'visible','off','units','pixels');
pos_fig = get(fig,'position');
set(fig,'position',[pos_fig(1:2),w_fig,h_fig]);

h.fig = fig;
h.exc = exc;

xNext = (w_fig-2*w_but-mg)/2;
yNext = mg;

h.pushbutton_ok = uicontrol('style','pushbutton','units','pixels','string',...
    'Save','callback',{@pushbutton_ok_Callback,fig},'position',...
    [xNext,yNext,w_but,h_but]);

xNext = xNext + w_but + mg;

h.pushbutton_cancel = uicontrol('style','pushbutton','units','pixels',...
    'string','Cancel','callback',{@pushbutton_cancel_Callback,fig},...
    'position',[xNext,yNext,w_but,h_but]);

xNext = mg;
yNext = h_fig - mg - h_intro;

h.text_intro = uicontrol('Style','text','horizontalalignment','left',...
    'position',[xNext,yNext,w_intro,h_intro]);
txt_intro = textwrap(h.text_intro,{cat(2,'Select the characteristic ',...
    'illumination of each ratio data (donor-specific illumination for ',...
    'FRET ratio and emitter-specific illumination for S ratio):')});
set(h.text_intro,'string',txt_intro);

for i = 1:R
    
    yNext = yNext - mg - h_text;
    
    h.text(i) = uicontrol('style','text','string',dlgtxt{i},...
        'position',[xNext,yNext,w_pop,h_text]);
    
    yNext = yNext - h_pop;
    
    h.popupmenu(i) = uicontrol('style','popupmenu','string',str_pop,...
        'value',1,'position',[xNext,yNext,w_pop,h_pop]);
    
    if i==halfSize
        xNext = xNext + w_pop + mg;
        yNext = h_fig - mg - h_intro;
    end
end

guidata(fig,h);

set(fig,'visible','on');


function pushbutton_ok_Callback(obj, evd, h_fig)
h = guidata(h_fig);
R = numel(h.popupmenu);
RATIO_EXC = zeros(1,R);
for i = 1:R
    RATIO_EXC(i) = h.exc(get(h.popupmenu(i),'value'));
end
set(h_fig,'userdata',RATIO_EXC);


function pushbutton_cancel_Callback(obj, evd, h_fig)
set(h_fig,'userdata',0);

