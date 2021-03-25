function pushbutton_tdp_impModel_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
def = p.proj{proj}.def{tag,tpe};
curr = p.proj{proj}.curr{tag,tpe};
mat = p.proj{proj}.prm{tag,tpe}.clst_start{1}(4);

if mat==1
    J = get(h.popupmenu_tdp_model,'Value') + 1;
else
    J = get(h.popupmenu_tdp_model,'Value');
end
curr.lft_start{2}(1) = J;
curr = ud_kinPrm(curr,def,curr.lft_start{2}(1));

h.param.TDP.proj{proj}.prm{tag,tpe} = curr;
h.param.TDP.proj{proj}.curr{tag,tpe} = curr;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');
