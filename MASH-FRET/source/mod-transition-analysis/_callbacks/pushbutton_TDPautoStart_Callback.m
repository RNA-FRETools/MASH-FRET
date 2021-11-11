function pushbutton_TDPautoStart_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% show process
setContPan('Estimating starting guess...','process',h_fig);

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

meth = curr.clst_start{1}(1);

if ~sum(meth==[1,3]) % not kmean or manual
    return
end

curr = setDefKmean(curr);

p.proj{proj}.TA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);

% bring TDP plot tab front
bringPlotTabFront('TAtdp',h_fig);

% update plots and GUI
updateFields(h_fig, 'TDP');

% show success
setContPan('Default starting guess successfully applied!','success',h_fig);

