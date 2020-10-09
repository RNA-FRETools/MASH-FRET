function pushbutton_TDPupdatePlot_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj; % current project
tpe = p.curr_type(proj); % current channel type
tag = p.curr_tag(proj); % current channel type

[p,ok,str] = buildTDP(p,tag,tpe);
if ~ok
    setContPan(str, 'warning', h_fig);
end

h.param.TDP = p;
guidata(h_fig, h);

% update plots and GUI
updateFields(h_fig, 'TDP');

