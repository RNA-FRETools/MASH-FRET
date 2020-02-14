function checkbox_impMov_Callback(obj, evd, h_fig)

% collect interface parameters
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

m{2}{1} = checked;

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);



