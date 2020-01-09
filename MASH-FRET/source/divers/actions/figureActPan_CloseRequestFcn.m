function figureActPan_CloseRequestFcn(obj,evd)
set(obj, 'Visible', 'off');
h = guidata(obj);
h_call = guidata(h.figure_MASH);
set(h_call.menu_showActPan, 'Checked', 'off');