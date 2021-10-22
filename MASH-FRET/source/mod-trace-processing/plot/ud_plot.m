function ud_plot(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_plot,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
nFRET = size(FRET,1);
nS = size(S,1);
labels = p.proj{proj}.labels;
exc = p.proj{proj}.excitations;
clr = p.proj{proj}.colours;
expT = p.proj{proj}.frame_rate;
p_fix = p.proj{proj}.TP.fix;
start = p.proj{proj}.TP.curr{mol}{2}{1}(4);
insec = p_fix{2}(7);
isfix = p_fix{2}(6);
perpix = p_fix{2}(5);
persec = p_fix{2}(4);

% set lists
if (nFRET+nS) > 0
    set(h.popupmenu_plotBottom, 'String', getStrPop('plot_botChan', ...
        {FRET S exc clr labels}), 'Value', p_fix{2}(3));
end
set(h.popupmenu_plotTop, 'String', getStrPop('plot_topChan', {labels ...
    p_fix{2}(1) clr{1}}), 'Value', p_fix{2}(2));

% set starting point
if insec
    start = start*expT;
end
set(h.edit_photobl_start,'string',num2str(start));
if isfix
    set(h.edit_photobl_start,'enable','inactive');
end

% set checkboxes
set(h.checkbox_photobl_fixStart,'value',isfix);
set(h.checkbox_photobl_insec,'value',insec);
set(h.checkbox_ttAveInt,'value',perpix);
set(h.checkbox_ttPerSec,'value',persec);
