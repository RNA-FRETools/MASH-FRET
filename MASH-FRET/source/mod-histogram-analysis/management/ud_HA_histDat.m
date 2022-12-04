function ud_HA_histDat(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
def = p.proj{proj}.HA.def{tag,tpe};
prm = p.proj{proj}.HA.prm{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

prm.plot{1} = curr.plot{1};
prm.plot([2,3]) = def.plot([2,3]);

ovrfl = prm.plot{1}(1,4);

[P,Ltot] = getHist('all',false, ovrfl, h_fig);
prm.plot{2} = P;
prm.plot{3} = Ltot;

curr.plot([2,3]) = prm.plot([2,3]);

p.proj{proj}.HA.prm{tag,tpe} = prm;
p.proj{proj}.HA.curr{tag,tpe} = curr;

h.param = p;
guidata(h_fig, h);
