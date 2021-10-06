function checkbox_dFRET_Callback(obj, evd, h_fig)

checked = get(obj, 'Value');
h = guidata(h_fig);

m = guidata(h.figure_trImpOpt);
m{1}{1}(9) = checked;

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);



