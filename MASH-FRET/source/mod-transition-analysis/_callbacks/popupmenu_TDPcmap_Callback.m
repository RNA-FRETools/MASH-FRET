function popupmenu_TDPcmap_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
tpe = p.TDP.curr_type(p.curr_proj);
tag = p.TDP.curr_tag(p.curr_proj);

val = obj.Value;

p.proj{p.curr_proj}.TA.curr{tag,tpe}.plot{4} = val;
p.proj{p.curr_proj}.TA.prm{tag,tpe}.plot{4} = val;

colormap(obj.String{val});

h.param = p;
guidata(h_fig,h);

% refresh panel
ud_TDPplot(h_fig);

% display success
str_pop = get(obj,'String');
setContPan([str_pop{val} ' colormap applied.'],'success',h_fig);