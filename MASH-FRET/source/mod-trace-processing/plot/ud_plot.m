function ud_plot(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_plot,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
nFRET = size(FRET,1);
nS = size(S,1);
labels = p.proj{proj}.labels;
exc = p.proj{proj}.excitations;
clr = p.proj{proj}.colours;
p_fix = p.proj{proj}.TP.fix;

if (nFRET+nS) > 0
    set(h.popupmenu_plotBottom, 'String', getStrPop('plot_botChan', ...
        {FRET S exc clr labels}), 'Value', p_fix{2}(3));
end
set(h.popupmenu_plotTop, 'String', getStrPop('plot_topChan', {labels ...
    p_fix{2}(1) clr{1}}), 'Value', p_fix{2}(2));
