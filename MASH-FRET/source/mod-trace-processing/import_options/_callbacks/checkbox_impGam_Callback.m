function checkbox_impGam_Callback(obj, evd, h_fig)

% Last update, 5.4.2019 by MH: saved empty file and directory for gamma import if the option is unselected

checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{6}{1} = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_fnameGam h.trImpOpt.pushbutton_impGamFile],...
            'Enable', 'on');
    case 0
        set([h.trImpOpt.text_fnameGam h.trImpOpt.pushbutton_impGamFile],...
            'Enable', 'off');
        
        % added by MH, 5.4.2019
        m{6}{2} = [];
        m{6}{3} = [];
        guidata(h.figure_trImpOpt, m);
end


