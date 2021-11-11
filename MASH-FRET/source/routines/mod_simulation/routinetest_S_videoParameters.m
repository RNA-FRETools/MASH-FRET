function routinetest_S_videoParameters(h_fig,p,prefix)
% routinetest_S_videoParameters(h_fig,p,prefix)
%
% Tests different camera noise distributions
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_S
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% default
expopt = [false,false,false,false,false,true,false]; % parameters to export only log files

h = guidata(h_fig);

% set interface defaults
setDefault_S(h_fig,p);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_S_videoParameters,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% generate state sequences with defaults
disp(cat(2,prefix,'test generation of state sequences...'));
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% test all camera noises (callbacks and calculations)
disp(cat(2,prefix,'test different camera noises...'));
str_pop = get(h.popupmenu_noiseType,'string');
nbcamnoise = numel(str_pop);
for n = 1:nbcamnoise
    
    disp(cat(2,prefix,'>> test "',str_pop{n},'" distribution...'));
    
    % set camera noise
    set_S_camNoise(n,p.camprm,h_fig);

    % update intensity calculations
    pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
    
    % export log file
    set_S_fileExport(expopt,h_fig);
    pushbutton_exportSim_Callback({p.dumpdir,'vidprm_camnoise'},[],h_fig);
end

