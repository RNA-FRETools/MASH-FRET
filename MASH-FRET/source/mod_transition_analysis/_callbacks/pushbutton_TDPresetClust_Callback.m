function pushbutton_TDPresetClust_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    p.proj{proj}.prm{tpe}.clst_res = cell(1,4);
    p.proj{proj}.prm{tpe}.kin_res = cell(1,5);
    h.param.TDP = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'TDP');
end