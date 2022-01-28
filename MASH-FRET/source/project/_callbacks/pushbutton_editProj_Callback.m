function pushbutton_editProj_Callback(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);
p = h.param;

% ask user for experiment settings
setExpSetWin(p.proj{p.curr_proj},'edit',h_fig);
