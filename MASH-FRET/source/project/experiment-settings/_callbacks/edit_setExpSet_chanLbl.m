function edit_setExpSet_chanLbl(obj,evd,h_fig,c)

proj = h_fig.UserData;

proj.labels{c} = get(obj,'string');

h_fig.UserData = proj;

ud_setExpSet_tabChan(h_fig);
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabDiv(h_fig);

