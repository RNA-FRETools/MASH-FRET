function popupmenu_tdp_model_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    J = get(obj,'Value')+1;
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    prm = p.proj{proj}.prm{tpe};
    if isempty(prm.clst_res{1}.mu{J})
        setContPan(cat(2,'No model inferred for this configuration. Press',...
        ' "Cluster" to infer new models.'),'warning',h.figure_MASH);
    end
    updateFields(h.figure_MASH, 'TDP');
end