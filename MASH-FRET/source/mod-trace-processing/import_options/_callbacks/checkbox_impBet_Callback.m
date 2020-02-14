function checkbox_impBet_Callback(obj, evd, h_fig)

checked = get(obj, 'Value');
h = guidata(h_fig);

m = guidata(h.figure_trImpOpt);
m{6}{4} = checked;

if ~checked
    % added by MH, 5.4.2019
    m{6}{5} = [];
    m{6}{6} = [];
end

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);


