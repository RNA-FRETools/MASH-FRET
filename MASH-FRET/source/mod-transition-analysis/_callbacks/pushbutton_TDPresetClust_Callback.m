function pushbutton_TDPresetClust_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

p.proj{proj}.prm{tag,tpe}.clst_res = p.proj{proj}.def{tag,tpe}.clst_res;
p.proj{proj}.prm{tag,tpe}.lft_start = p.proj{proj}.def{tag,tpe}.lft_start;
p.proj{proj}.prm{tag,tpe}.lft_res = p.proj{proj}.def{tag,tpe}.lft_res;
p.proj{proj}.prm{tag,tpe}.mdl_res = p.proj{proj}.def{tag,tpe}.mdl_res;
p.proj{proj}.curr{tag,tpe}.clst_res = p.proj{proj}.prm{tag,tpe}.clst_res;
p.proj{proj}.curr{tag,tpe}.lft_start = p.proj{proj}.prm{tag,tpe}.lft_start;
p.proj{proj}.curr{tag,tpe}.lft_res = p.proj{proj}.prm{tag,tpe}.lft_res;
p.proj{proj}.curr{tag,tpe}.mdl_res = p.proj{proj}.prm{tag,tpe}.mdl_res;

h.param.TDP = p;
guidata(h_fig, h);

% update plots and GUI
updateFields(h_fig, 'TDP');
