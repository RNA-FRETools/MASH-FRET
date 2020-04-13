function edit_nMol_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = 20;
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 && ...
        val <= max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Number of molecules per figure must be > 0 and <= 8.',...
        h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(3) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


