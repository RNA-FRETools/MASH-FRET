function edit_setExpSet_nChan(obj,evd,h_fig)

% retrieve project data
proj = h_fig.UserData;

nChan = str2double(get(obj,'string'));
if isempty(nChan)
    nChan = 0;
end
if nChan<0
    nChan = 0;
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

% update project data
h_fig.UserData = proj;

% refresh data ratio calculations
cleanRatioCalc(h_fig);

% refresh plot colors
ud_plotColors(h_fig);

% refresh trajectory file import options
ud_trajImportOpt(h_fig);

% refresh channel tab
h = guidata(h_fig);
h = setExpSet_buildChanArea(h,nChan);
guidata(h_fig,h);

% refresh channel plot
ud_expSet_chanPlot(h_fig);

% refresh interface
ud_setExpSet_tabChan(h_fig);
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabFstrct(h_fig)
ud_setExpSet_tabDiv(h_fig);

