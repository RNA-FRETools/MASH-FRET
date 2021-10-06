function popupmenu_TA_mdlMeth_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

p.proj{proj}.TA.curr{tag,tpe}.mdl_start(1) = get(obj,'value');

h.param = p;
guidata(h_fig, h);

ud_kinMdl(h_fig);
updateTAplots(h_fig,'mdl');
