function checkbox_extFile_Callback(obj, evd, h_fig)

checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

m{3}{1} = checked;
if checked
    m{4}(1) = false;
end

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);


