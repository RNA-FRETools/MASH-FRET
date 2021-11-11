function pushbutton_TDPresetClust_Callback(obj, evd, h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% show process
setContPan('Resets cluster results...','process',h_fig);

proj = p.curr_proj;
tag = p.TDP.curr_tag(proj);
tpe = p.TDP.curr_type(proj);
def = p.proj{proj}.TA.def{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe};
curr = p.proj{proj}.TA.curr{tag,tpe};

prm.clst_res = def.clst_res;
prm.lft_start = def.lft_start;
prm.lft_res = def.lft_res;
prm.mdl_res = def.mdl_res;
curr.clst_res = prm.clst_res;
curr.lft_start = prm.lft_start;
curr.lft_res = prm.lft_res;
curr.mdl_res = prm.mdl_res;

p.proj{proj}.TA.prm{tag,tpe} = prm;
p.proj{proj}.TA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);

% update plots and GUI
updateFields(h_fig, 'TDP');

% bring average image plot tab front
bringPlotTabFront('TAtdp',h_fig);

% show process
setContPan('Cluster results were successfully reset','process',h_fig);
