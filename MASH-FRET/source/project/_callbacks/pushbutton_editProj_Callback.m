function pushbutton_editProj_Callback(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);
p = h.param;

% ask user for experiment settings
if ~isempty(p.proj{p.curr_proj}.sim)
    setExpSetWin(p.proj{p.curr_proj},'sim',h_fig);
else
    setExpSetWin(p.proj{p.curr_proj},'edit',h_fig);
end
