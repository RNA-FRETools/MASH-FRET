function checkbox_impBet_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{6}{4} = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_fnameBet h.trImpOpt.pushbutton_impBetFile],...
            'Enable', 'on');
    case 0
        set([h.trImpOpt.text_fnameBet h.trImpOpt.pushbutton_impBetFile],...
            'Enable', 'off');
        
        % added by MH, 5.4.2019
        m{6}{5} = [];
        m{6}{6} = [];
        guidata(h.figure_trImpOpt, m);
end


