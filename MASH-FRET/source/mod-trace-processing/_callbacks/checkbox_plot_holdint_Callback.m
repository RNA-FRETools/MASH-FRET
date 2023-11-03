function checkbox_plot_holdint_Callback(obj,evd,h_fig)

% retrieve project data
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;

% modify parameter "hold intensity scale"
p.proj{proj}.TP.fix{2}(7) = get(obj,'value');

% save modification to project data
h.param = p;
guidata(h_fig,h);

% update interface
updateFields(h_fig,'ttPr');