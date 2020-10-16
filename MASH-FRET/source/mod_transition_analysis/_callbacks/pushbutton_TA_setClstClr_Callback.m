function pushbutton_TA_setClstClr_Callback(obj,evd,h_fig)

rgb = uisetcolor('Select a cluster color');
if numel(rgb)==1
    return
end

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

k = get(h.popupmenu_TA_setClstClr, 'Value');
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

p.proj{proj}.prm{tag,tpe}.clst_start{3}(k,:) = rgb;

h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');