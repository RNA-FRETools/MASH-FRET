function pushbutton_showDark_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    dispDarkTr(h.figure_MASH);
end