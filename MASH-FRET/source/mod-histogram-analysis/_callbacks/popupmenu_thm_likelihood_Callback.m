function popupmenu_thm_likelihood_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);

p.proj{proj}.HA.curr{tag,tpe}.thm_start{4}(4) = get(obj,'value');
    
h.param = p;
guidata(h_fig, h);
updateFields(h_fig,'thm');