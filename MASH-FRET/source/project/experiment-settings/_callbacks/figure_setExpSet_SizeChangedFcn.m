function figure_setExpSet_SizeChangedFcn(h_fig,evd)
h = guidata(h_fig);
if isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct)
    setExpSet_adjTblPos(h_fig);
end