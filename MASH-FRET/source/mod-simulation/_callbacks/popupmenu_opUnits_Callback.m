function popupmenu_opUnits_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

switch get(obj, 'Value')
    case 1
        p.proj{p.curr_proj}.sim.curr.exp{2} = 'photon';
    case 2
        p.proj{p.curr_proj}.sim.curr.exp{2} = 'electron';
end

h.param = p;
guidata(h_fig, h);

% update plots
refreshPlotExample(h_fig);
plotData_sim(h_fig);