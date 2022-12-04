function push_setExpSet_remS(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);

%retrieve project content
proj = h_fig.UserData;

if isempty(proj.S)
    return
end
s = get(h.list_S,'value');
proj.S(s,:) = [];

% save modifications
h_fig.UserData = proj;

% refresh plot colors
ud_plotColors(h_fig);

% refresh interface
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabDiv(h_fig);