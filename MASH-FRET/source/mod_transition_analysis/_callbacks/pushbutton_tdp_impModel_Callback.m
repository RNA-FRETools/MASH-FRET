function pushbutton_tdp_impModel_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
curr = p.proj{proj}.curr{tag,tpe};
def = p.proj{proj}.curr{tag,tpe};

curr.kin_start{2}(1) = get(h.popupmenu_tdp_model,'Value') + 1;
curr = ud_kinPrm(curr,def,curr.kin_start{2}(1));

h.param.TDP.proj{proj}.curr{tag,tpe} = curr;
h.param.TDP.proj{proj}.prm{tag,tpe}.kin_start = curr.kin_start;
h.param.TDP.proj{proj}.prm{tag,tpe}.kin_res = curr.kin_res;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');