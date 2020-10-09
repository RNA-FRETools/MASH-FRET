function ESlinRegOpt(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

h_fig2 = build_ESlinRegOpt(h_fig);

setDefPrm_ESlinRegOpt(h_fig,h_fig2);

ud_EScalc(h_fig,h_fig2);

ud_ESlinRegOpt(h_fig,h_fig2);


