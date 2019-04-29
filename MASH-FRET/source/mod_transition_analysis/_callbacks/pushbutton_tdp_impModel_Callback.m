function pushbutton_tdp_impModel_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    prm = p.proj{proj}.prm{tpe};

    prm.clst_res{3} = get(h.popupmenu_tdp_model,'Value') + 1;
    prm = ud_kinPrm(prm,prm.clst_res{3});

    h.param.TDP.proj{proj}.prm{tpe} = prm;
    guidata(h.figure_MASH,h);
    updateFields(h.figure_MASH, 'TDP');
end