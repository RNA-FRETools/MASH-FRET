function pushbutton_TA_setClstClr_Callback(obj,evd,h_fig)

rgb = uisetcolor('Select a cluster color');
if numel(rgb)==1
    return
end

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% show process
setContPan('Setting cluster color...','process',h_fig);

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

k = get(h.popupmenu_TA_setClstClr, 'Value');

p.proj{proj}.TA.curr{tag,tpe}.clst_start{3}(k,:) = rgb;
p.proj{proj}.TA.prm{tag,tpe}.clst_start{3}(k,:) = rgb;

h.param = p;
guidata(h_fig, h);

% bring TDP plot tab front
bringPlotTabFront('TAtdp',h_fig);

% refresh TDP interface
updateFields(h_fig, 'TDP');

% show process
setContPan('Cluster color successfully set!','success',h_fig);
