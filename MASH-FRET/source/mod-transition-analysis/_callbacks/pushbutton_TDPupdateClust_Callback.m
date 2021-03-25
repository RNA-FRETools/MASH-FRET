function pushbutton_TDPupdateClust_Callback(obj, evd, h_fig)

% Last update by MH, 27.1.2020: move clustering script to separate function clusterTDP.m and update dwell time histogram plot after clustering

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% TDP
p = clusterTDP(p,tag,tpe,h_fig);

% save results
h.param.TDP = p;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');

