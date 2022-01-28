function pop_setExpSet_delim(obj,evd,h_fig)

% default
maxflines = 100;

% update delimiter
proj = get(h_fig,'userdata');
proj.traj_import_opt{1}{1}(2) = get(obj,'value');
set(h_fig,'userdata',proj);
if ~isfield(proj,'traj_files')
    return
end

% reset file data
switch proj.traj_import_opt{1}{1}(2)
    case 1
        delimchar = {sprintf('\t'),' '};
    case 2
        delimchar = sprintf('\t');
    case 3
        delimchar = ',';
    case 4
        delimchar = ';';
    case 5
        delimchar = ' ';
    otherwise
        delimchar = sprintf('\t');
end

% read first 100 file lines
fdat = {};
fline = 0;
pname = proj.traj_files{1};
fname = proj.traj_files{2};
f = fopen([pname,fname{1}],'r');
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

% refresh trajectory import options
ud_trajImportOpt(h_fig);

% refresh panel
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);
