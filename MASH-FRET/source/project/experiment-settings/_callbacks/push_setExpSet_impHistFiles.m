function push_setExpSet_impHistFiles(obj,evd,h_fig,h_fig0)

% default
maxflines = 100;

% retrieve project data
proj = h_fig.UserData;

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
else
    % ask for trajectory files
    [fname,pname,~] = uigetfile({'*.*','All files(*.*)'},...
        'Select one histogram file',proj.folderRoot,'MultiSelect','off');
    if ~sum(pname)
        return
    end
end
if pname(end)~=filesep
    pname = [pname,filesep];
end
cd(pname);

% display process
setContPan(['Import histogram from folder: ',pname,' ...'],'process',...
    h_fig0);

proj.hist_file = {pname,fname};

switch proj.hist_import_opt(2)
    case 1
        delimchar = {sprintf('\t'),' ',' '};
    case 2
        delimchar = sprintf('\t');
    case 3
        delimchar = ',';
    case 4
        delimchar = ';';
    case 5
        delimchar = {' ',' '};
    otherwise
        delimchar = sprintf('\t');
end

% read first 100 file lines
fdat = {};
fline = 0;
f = fopen([pname,fname],'r');
while fline<maxflines && ~feof(f)
    rowdat = split(fgetl(f),delimchar)';
    excl = false(1,numel(rowdat));
    for col = 1:numel(rowdat)
        chars = unique(rowdat{col});
        if numel(chars)==0 || (numel(chars)==1 && chars==' ')
            excl(col) = true;
        end
    end
    rowdat(excl) = [];
    if ~isempty(fdat) && size(rowdat,2)~=size(fdat,2)
        if size(rowdat,2)<size(fdat,2)
            rowdat = cat(2,rowdat,...
                cell(1,size(fdat,2)-size(rowdat,2)));
        else
            fdat = cat(2,fdat,...
                cell(size(fdat,1),size(rowdat,2)-size(fdat,2)));
        end
    end
    fdat = cat(1,fdat,rowdat);
    fline = fline+1;
end
fclose(f);

% store file content
h = guidata(h_fig);
set(h.table_fstrct,'userdata',fdat);

% save modifications
h_fig.UserData = proj;

ud_setExpSet_tabImp(h_fig);
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);

% display success
setContPan('Histogram successfully imported!','success',h_fig0);
