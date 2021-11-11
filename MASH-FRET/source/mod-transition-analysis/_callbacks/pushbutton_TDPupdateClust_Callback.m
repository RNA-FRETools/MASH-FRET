function pushbutton_TDPupdateClust_Callback(obj, evd, h_fig)

% Last update by MH, 27.1.2020: move clustering script to separate function clusterTDP.m and update dwell time histogram plot after clustering

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% show process
setContPan('Start TDP clustering...','process',h_fig);

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

% TDP
[p,ok] = clusterTDP(p,tag,tpe,h_fig);
if ~ok
    return
end

% save results
h.param = p;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');

% bring average image plot tab front
bringPlotTabFront('TAtdp',h_fig);

% show process
setContPan('TDP clustering successfully completed!','process',h_fig);

