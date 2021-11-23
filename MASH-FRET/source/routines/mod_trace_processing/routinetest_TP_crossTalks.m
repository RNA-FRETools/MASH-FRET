function routinetest_TP_crossTalks(h_fig,p,prefix)
% routinetest_TP_crossTalks(h_fig,p,prefix)
%
% Tests bleedthrough and direct excitation coefficients
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP

h = guidata(h_fig);

% open default project
disp(cat(2,prefix,'import file ',p.mash_files{p.nL,p.nChan}));
pushbutton_openProj_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},...
    [],h_fig);

% set default parameters
setDefault_TP(h_fig,p);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_TP_crossTalks,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
h = guidata(h_fig);
proj = h.param.proj{h.param.curr_proj};
set_TP_crossTalks(p.bt,p.de,proj.chanExc,proj.excitations,h_fig);

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);

