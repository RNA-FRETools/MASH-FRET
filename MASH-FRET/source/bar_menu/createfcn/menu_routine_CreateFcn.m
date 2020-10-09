function menu_routine_CreateFcn(obj,evd,h)

h_fig = get(obj,'Parent');

uimenu(obj,'Label','routine 01','Callback',{@ttPr_routine,1,h_fig});
uimenu(obj,'Label','routine 02','Callback',{@ttPr_routine,2,h_fig});
uimenu(obj,'Label','routine 03','Callback',{@ttPr_routine,3,h_fig});
uimenu(obj,'Label','routine 04','Callback',{@ttPr_routine,4,h_fig});