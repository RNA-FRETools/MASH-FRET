function popupmenu_tdp_model_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
mat = p.proj{proj}.prm{tag,tpe}.clst_start{1}(4);
if mat==1
    J = get(obj,'Value')+1;
else
    J = get(obj,'Value');
end

p.proj{proj}.curr{tag,tpe}.clst_res{3} = J;

h.param.TDP = p;
guidata(h_fig,h);

updateFields(h_fig, 'TDP');