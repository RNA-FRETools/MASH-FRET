function edit_setExpSet_excWl(obj,evd,h_fig,l)

proj = h_fig.UserData;

wl = str2double(get(obj,'string'));
if ~(isnumeric(wl) && wl>0)
    wl = 0;
end

proj.chanExc(proj.chanExc==proj.excitations(l)) = wl;
proj.excitations(l) = wl;

h_fig.UserData = proj;

% refresh time section in file structure tab
h = guidata(h_fig);
if isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct)
    h = setExpSet_buildTimeArea(h,proj.excitations);
    guidata(h_fig,h);
end

ud_expSet_excPlot(h_fig);
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);