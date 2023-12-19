function edit_setExpSet_hLines(obj,evd,h_fig)

% determine data to structure
h = guidata(h_fig);
istraj = isfield(h,'text_impTrajFiles') && ishandle(h.text_impTrajFiles);

val = round(str2double(get(obj,'string')));
set(obj,'string',num2str(val));

proj = get(h_fig,'userdata');
if istraj
    proj.traj_import_opt{1}{1}(1) = val;
else
    proj.hist_import_opt(1) = val;
end
set(h_fig,'userdata',proj);

% adjust import options
if istraj
    ud_trajImportOpt(h_fig);
else
    ud_histImportOpt(h_fig)
end

% refresh panel
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);