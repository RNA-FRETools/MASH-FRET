function routinetest_TP_crossTalks(h_fig,p)
% routinetest_TP_crossTalks(h_fig,p)
%
% Tests bleedthrough and direct excitation coefficients
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP

h = guidata(h_fig);

setDefault_TP(h_fig,p);

set_TP_crossTalks(p.bt,p.de,p.projOpt{p.nL,p.nChan}.chanExc,p.wl(1:p.nL),...
    h_fig);

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

