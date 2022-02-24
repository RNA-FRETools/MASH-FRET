function edit_setExpSet_nChan(obj,evd,h_fig,h_fig0)

% retrieve project data
proj = h_fig.UserData;

nChan = str2double(get(obj,'string'));
if isempty(nChan)
    nChan = 1;
end
if nChan<1
    nChan = 1;
end
if nChan>10
    nChan = 10;
end
proj.nb_channel = nChan;

for c = 1:nChan
    if c>numel(proj.labels)
        proj.labels = [proj.labels,['chan',num2str(c)]];
    end
    if c>numel(proj.chanExc)
        proj.chanExc = [proj.chanExc,0];
    end
end
proj.labels = proj.labels(1:nChan);
proj.chanExc = proj.chanExc(1:nChan);

% update video param
h = guidata(h_fig);
proj = updateProjVideoParam(proj,h.radio_impFileMulti.Value);

% update project data
h_fig.UserData = proj;

% refresh data ratio calculations
cleanRatioCalc(h_fig);

% refresh plot colors
ud_plotColors(h_fig);

% refresh trajectory file import options
ud_trajImportOpt(h_fig);

% rebuild channel and video area
h = guidata(h_fig);
h = setExpSet_buildChanArea(h,nChan);
h = setExpSet_buildVideoArea(h,nChan,h_fig0);
guidata(h_fig,h);

% refresh channel plot
ud_expSet_chanPlot(h_fig);

% refresh interface
ud_setExpSet_tabImp(h_fig);
ud_setExpSet_tabChan(h_fig);
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabFstrct(h_fig)
ud_setExpSet_tabDiv(h_fig);

