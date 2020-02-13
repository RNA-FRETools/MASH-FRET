function checkbox_inTTfile_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

switch checked
    case 1
        set([h.trImpOpt.text_rowCoord h.trImpOpt.edit_rowCoord], ...
            'Enable', 'on');
        set([h.trImpOpt.pushbutton_impCoordFile  ...
            h.trImpOpt.text_fnameCoord ...
            h.trImpOpt.pushbutton_impCoordOpt, ...
            h.trImpOpt.edit_movWidth, h.trImpOpt.text_movWidth], ...
            'Enable', 'off');
        set(h.trImpOpt.checkbox_extFile, 'Value', 0);
    case 0
        set([h.trImpOpt.text_rowCoord h.trImpOpt.edit_rowCoord], ...
            'Enable', 'off');
end

m{4}(1) = checked;
m{3}{1} = get(h.trImpOpt.checkbox_extFile, 'Value');
guidata(h.figure_trImpOpt, m);


