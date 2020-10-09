function popupmenu_TDP_expNum_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    p.proj{proj}.prm{tpe}.kin_start{trs,1}(3) = get(obj, 'Value');
    h.param.TDP = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'TDP');
end