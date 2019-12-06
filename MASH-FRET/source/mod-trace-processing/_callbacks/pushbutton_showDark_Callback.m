function pushbutton_showDark_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    dispDarkTr(h_fig);
end