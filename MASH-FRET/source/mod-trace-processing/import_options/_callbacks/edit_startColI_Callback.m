function edit_startColI_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('First column number must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(5) = val;
    guidata(h.figure_trImpOpt, m);
end


