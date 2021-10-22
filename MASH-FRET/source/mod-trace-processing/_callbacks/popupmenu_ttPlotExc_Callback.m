function popupmenu_ttPlotExc_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
labels = p.proj{p.curr_proj}.labels;
clr = p.proj{p.curr_proj}.colours;

val = get(obj, 'Value');
set(h.popupmenu_plotTop,'String',...
    getStrPop('plot_topChan',{labels val clr{1}}));

p.proj{p.curr_proj}.TP.fix{2}(1) = val;

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');
