function checkbox_TDPboba_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    p.proj{proj}.prm{tpe}.clst_start{1}(6) = get(obj, 'Value');
    h.param.TDP = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'TDP');
end