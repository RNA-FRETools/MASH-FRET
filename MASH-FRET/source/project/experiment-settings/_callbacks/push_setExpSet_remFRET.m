function push_setExpSet_remFRET(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);

%retrieve project content
proj = h_fig.UserData;

if isempty(proj.FRET)
    return
end
fret = get(h.list_FRET,'value');
proj.FRET(fret,:) = [];

% save modifications
h_fig.UserData = proj;

% refresh data ratio calculations
cleanRatioCalc(h_fig);

% refresh plot colors
ud_plotColors(h_fig);

% refresh interface
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabDiv(h_fig);

