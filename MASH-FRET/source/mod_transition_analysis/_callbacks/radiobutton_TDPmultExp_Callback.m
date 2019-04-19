function radiobutton_TDPmultExp_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    kin_k = p.proj{proj}.prm{tpe}.kin_start;
    if kin_k{trs,1}(1) == get(obj, 'Value') && kin_k{trs,1}(1)
        kin_k{trs,1}(1) = ~get(obj, 'Value');
        p.proj{proj}.prm{tpe}.kin_start = kin_k;
        p.proj{proj}.prm{tpe}.kin_res(trs,:) = cell(1,5);
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
    end
    updateFields(h.figure_MASH, 'TDP');
end