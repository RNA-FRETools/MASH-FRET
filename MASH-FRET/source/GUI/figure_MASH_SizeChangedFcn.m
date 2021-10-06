function figure_MASH_SizeChangedFcn(obj, evd)

h = guidata(obj);

% re-adjust text wrapping in control panel
str = wrapActionString('resize',h.edit_actPan,...
    [h.figure_dummy,h.text_dummy]);
set(h.edit_actPan,'String',str);

