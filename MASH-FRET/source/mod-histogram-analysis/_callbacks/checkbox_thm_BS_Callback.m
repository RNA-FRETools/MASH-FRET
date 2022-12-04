function checkbox_thm_BS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);

p.proj{proj}.HA.prm{tag,tpe}.thm_start{1}(2) = get(obj, 'Value');
p.proj{proj}.HA.prm{tag,tpe}.thm_res(1,1:3) = {[] [] []};
p.proj{proj}.HA.prm{tag,tpe}.thm_res(2,1:3) = {[] [] []};
    
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');