function popupmenu_tdp_model_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

J = get(obj,'Value')+1;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

p.proj{proj}.curr{tag,tpe}.clst_res{3} = J;

h.param.TDP = p;
guidata(h_fig,h);

updateFields(h_fig, 'TDP');