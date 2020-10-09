function backgroundAnalyser(h_fig)

% build backgorund analyzer GUI
h_fig2 = buildBackgroundAnalyzer(h_fig);

q = guidata(h_fig2);

% initialize variables
[ok,q.param,q.curr_m,q.curr_l,q.curr_c] = setDefBganaPrm(h_fig);
if ~ok
    close all force;
    return
end
q.res = [];

h = guidata(h_fig);

h.figure_bgopt = h_fig2;
h.bga = q;
guidata(h_fig,h);

h.bga.pushbutton_help = setInfoIcons(q.pushbutton_save,h_fig,...
    h.param.movPr.infos_icon_file);

% update q structure
q = h.bga;
guidata(h_fig2,q);
guidata(h_fig,h);

ud_BAfields(h_fig2);

set(h_fig2,'visible','on');
