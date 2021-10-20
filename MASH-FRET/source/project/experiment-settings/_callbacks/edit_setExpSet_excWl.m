function edit_setExpSet_excWl(obj,evd,h_fig,l)

proj = h_fig.UserData;

wl = str2double(get(obj,'string'));
if ~(isnumeric(wl) && wl>0)
    wl = 0;
end

proj.chanExc(proj.chanExc==proj.excitations(l)) = wl;
proj.excitations(l) = wl;

h_fig.UserData = proj;

ud_expSet_excPlot(h_fig);
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabDiv(h_fig);