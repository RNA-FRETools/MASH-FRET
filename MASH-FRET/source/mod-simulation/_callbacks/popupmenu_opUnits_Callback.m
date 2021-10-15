function popupmenu_opUnits_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

switch get(obj, 'Value')
    case 1
        p.proj{p.curr_proj}.sim.curr.gen_dat{3}{2} = 'photon';
    case 2
        p.proj{p.curr_proj}.sim.curr.gen_dat{3}{2} = 'electron';
end

h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'sim');