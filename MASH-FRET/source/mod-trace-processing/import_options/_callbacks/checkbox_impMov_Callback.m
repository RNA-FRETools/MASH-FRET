function checkbox_impMov_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{2}{1} = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_fnameMov h.trImpOpt.pushbutton_impMovFile],...
            'Enable', 'on');
    case 0
        set([h.trImpOpt.text_fnameMov h.trImpOpt.pushbutton_impMovFile],...
            'Enable', 'off');
end


