function ud_plot(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
p_fix = p.proj{proj}.fix;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
nFRET = size(FRET,1);
nS = size(S,1);
labels = p.proj{proj}.labels;
exc = p.proj{proj}.excitations;

if (nFRET+nS) > 0
    set(h.popupmenu_plotBottom, 'String', getStrPop('plot_botChan', ...
        {FRET S exc p.proj{proj}.colours labels}), 'Value', p_fix{2}(3));
end
set(h.popupmenu_plotTop, 'String', getStrPop('plot_topChan', {labels ...
    p_fix{2}(1) p.proj{proj}.colours{1}}), 'Value', p_fix{2}(2));