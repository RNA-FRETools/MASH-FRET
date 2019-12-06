function pushbutton_tdp_impModel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    prm = p.proj{proj}.prm{tpe};

    prm.clst_res{3} = get(h.popupmenu_tdp_model,'Value') + 1;
    prm = ud_kinPrm(prm,prm.clst_res{3});

    h.param.TDP.proj{proj}.prm{tpe} = prm;
    guidata(h_fig,h);
    updateFields(h_fig, 'TDP');
end