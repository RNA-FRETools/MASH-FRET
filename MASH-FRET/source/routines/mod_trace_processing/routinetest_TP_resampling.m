function routinetest_TP_resampling(h_fig,p,prefix)
% routinetest_TP_resampling(h_fig,p,prefix)
%
% Tests trajectory resampling
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

% open default project
disp(cat(2,prefix,'import file ',p.mash_files{p.nL,p.nChan}));
pushbutton_openProj_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},...
    [],h_fig);

% set default parameters
setDefault_TP(h_fig,p);

% get interface parameters
h = guidata(h_fig);
proj = h.param.proj{h.param.curr_proj};

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_TP_sampling,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% test trajectory resampling
disp(cat(2,prefix,'test trajectory resampling...'));
set_TP_resampling(2*proj.sampling_time,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
