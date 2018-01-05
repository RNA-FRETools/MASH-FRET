function target_centroids(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    prm = p.proj{proj}.prm{tpe};
    bin_x = prm.plot{1}(1,1);
    state = get(h.popupmenu_TDPstate, 'Value');
    
    newPnt = get(h.axes_TDPplot1, 'CurrentPoint');
    newPnt(1,1) = round(newPnt(1,1)/bin_x)*bin_x;
    
    prm.clst_start{2}(state,1) = newPnt(1,1);
    p.proj{proj}.prm{tpe} = prm;
    h.param.TDP = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'TDP');
end