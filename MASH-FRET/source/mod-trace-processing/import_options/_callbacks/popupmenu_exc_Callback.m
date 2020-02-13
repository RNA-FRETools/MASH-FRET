function popupmenu_exc_Callback(obj, evd, h_fig)
exc = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
set(h.trImpOpt.edit_wl, 'String', num2str(m{1}{2}(exc)));


