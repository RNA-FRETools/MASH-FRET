function pushbutton_tdp_impModel_Callback(obj, evd, h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tag = p.TDP.curr_tag(proj);
tpe = p.TDP.curr_type(proj);
def = p.proj{proj}.TA.def{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe};
curr = p.proj{proj}.TA.curr{tag,tpe};

mat = prm.clst_start{1}(4);

if mat==1
    J = get(h.popupmenu_tdp_model,'Value') + 1;
else
    J = get(h.popupmenu_tdp_model,'Value');
end
curr.lft_start{2}(1) = J;
curr = ud_kinPrm(curr,def,curr.lft_start{2}(1));

p.proj{proj}.TA.prm{tag,tpe} = curr;
p.proj{proj}.TA.curr{tag,tpe} = curr;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');
