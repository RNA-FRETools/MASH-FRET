function checkbox_dFRET_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{1}{1}(9) = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_every h.trImpOpt.edit_thcol ...
            h.trImpOpt.text_thcol], 'Enable', 'on');
    case 0
        set([h.trImpOpt.text_every h.trImpOpt.edit_thcol ...
            h.trImpOpt.text_thcol], 'Enable', 'off');
end


