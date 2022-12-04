function push_setExpSet_defclr(obj,evd,h_fig)

% retrieve project content
proj = h_fig.UserData;

% set default colors
defclr = getDefTrClr(proj.nb_excitations,proj.excitations,proj.nb_channel,...
    size(proj.FRET,1),size(proj.S,1));
proj.colours = defclr;

h_fig.UserData = proj;

% update interface
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);