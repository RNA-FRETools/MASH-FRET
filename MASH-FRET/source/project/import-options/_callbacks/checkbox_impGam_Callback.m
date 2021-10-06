function checkbox_impGam_Callback(obj, evd, h_fig)

% Last update, 5.4.2019 by MH: saved empty file and directory for gamma import if the option is unselected

checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

m{6}{1} = checked;

if ~checked
    % added by MH, 5.4.2019
    m{6}{2} = [];
    m{6}{3} = [];
end

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);


