function popupmenu_tdp_model_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

mat = p.proj{proj}.TA.prm{tag,tpe}.clst_start{1}(4);
if mat==1
    J = get(obj,'Value')+1;
else
    J = get(obj,'Value');
end

p.proj{proj}.TA.curr{tag,tpe}.clst_res{3} = J;

h.param = p;
guidata(h_fig,h);

updateFields(h_fig, 'TDP');