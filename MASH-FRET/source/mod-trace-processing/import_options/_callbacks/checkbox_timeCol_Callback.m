function checkbox_timeCol_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{1}{1}(3) = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_timeCol h.trImpOpt.edit_timeCol], ...
            'Enable', 'on');
    case 0
        set([h.trImpOpt.text_timeCol h.trImpOpt.edit_timeCol], ...
            'Enable', 'off');
end


