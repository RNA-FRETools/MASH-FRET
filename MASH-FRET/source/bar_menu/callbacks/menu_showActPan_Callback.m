function menu_showActPan_Callback(obj, evd, h_fig)
h = guidata(h_fig);
checked = strcmp(get(obj, 'Checked'), 'on');
if ~checked
    if isfield(h, 'figure_actPan') && ishandle(h.figure_actPan)
        set(h.figure_actPan, 'Visible', 'on');
    else
        h.figure_actPan = actionPanel(h_fig);
        guidata(h_fig, h);
    end
    set(obj, 'Checked', 'on');
else
    if isfield(h, 'figure_actPan') && ishandle(h.figure_actPan)
        set(h.figure_actPan, 'Visible', 'off');
    end
    set(obj, 'Checked', 'off');
end