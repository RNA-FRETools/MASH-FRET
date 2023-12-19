function edit_setExpSet_xval(obj,evd,h_fig)

% get new value
val = round(str2double(get(obj,'string')));
set(obj,'string',num2str(val));

% save modifications
proj = get(h_fig,'userdata');
proj.hist_import_opt(3) = val;
set(h_fig,'userdata',proj);

% adjust import options
ud_histImportOpt(h_fig)

% refresh panels
ud_setExpSet_tabDiv(h_fig);
ud_setExpSet_tabFstrct(h_fig);