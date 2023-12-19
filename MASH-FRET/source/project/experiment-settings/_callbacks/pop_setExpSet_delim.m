function pop_setExpSet_delim(obj,evd,h_fig)

% default
maxflines = 100;

% determine data to structure
h = guidata(h_fig);
istraj = isfield(h,'text_impTrajFiles') && ishandle(h.text_impTrajFiles);

% update delimiter
proj = get(h_fig,'userdata');
delim = get(obj,'value');
if istraj
    proj.traj_import_opt{1}{1}(2) = delim;
else
    proj.hist_import_opt(2) = delim;
end
set(h_fig,'userdata',proj);
if (istraj && ~isfield(proj,'traj_files')) || ...
        (~istraj && ~isfield(proj,'hist_file'))
    return
end

% reset file data
if istraj
    pname = proj.traj_files{1};
    fname = proj.traj_files{2}{1};
else
    pname = proj.hist_file{1};
    fname = proj.hist_file{2};
end
delimchar = collectsdelimchar(proj.hist_import_opt(2));
fdat = readfirstflines(pname,fname,delimchar,maxflines);

% store file content
set(h.table_fstrct,'userdata',fdat);

if istraj
    % refresh trajectory import options
    ud_trajImportOpt(h_fig);
else
    % refresh histogram import options
    ud_histImportOpt(h_fig);
end

% refresh panel
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);
