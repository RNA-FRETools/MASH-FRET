function pushbutton_TP_pbStats_Callback(obj,evd,fig0)

% build Photobleaching/blinking figure
fig = buildPbStatsFig(fig0);

% store handle to Photobleaching/blinking figure in main structure
h = guidata(fig0);
h.figure_pbStats = fig;
guidata(fig0,h);

% update Photobleaching/blinking stats and plot
ud_pbstats([],[],fig);