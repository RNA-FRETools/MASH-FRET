function edit_nbChan_Callback(obj, evd, h_fig)

val = round(str2num(get(obj, 'String')));

set(obj, 'String', num2str(val));
if ~(numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Number of channel must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{1}{1}(7) = val;
    
    % save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);



