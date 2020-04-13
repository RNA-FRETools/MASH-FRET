function routinetest_S_molecules(h_fig,p,prefix)
% routinetest_S_molecules(h_fig,p,prefix)
%
% Tests coordinates import, presets import and photobleaching
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_S
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% default
expopt = [false,false,false,false,false,true,false]; % parameters to export only log files

h = guidata(h_fig);

% set interface defaults
setDefault_S(h_fig,p);

% generate state sequences with defaults
disp(cat(2,prefix,'test generation of state sequences...'));
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% test coordinates import
disp(cat(2,prefix,'test coordinates import...'));
C = size(p.coordfiles,2);
for c = 1:C
    disp(cat(2,prefix,'>> import of ',p.coordfiles{c},'...'));
    
    % import file
    pushbutton_simImpCoord_Callback({p.annexpth,p.coordfiles{c}},[],h_fig);
    
    % update data
    ok = pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
    if ~ok
        pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);
    end
    
    % export log file
    set_S_fileExport(expopt,h_fig);
    pushbutton_exportSim_Callback({p.dumpdir,sprintf('mol_coord_%i',c)},[],...
        h_fig);
end
pushbutton_simRemCoord_Callback(h.pushbutton_simRemCoord,[],h_fig);

% test presets import
disp(cat(2,prefix,'test presets import...'));
C = size(p.presetfiles,2);
for c = 1:C
    disp(cat(2,prefix,'>> import of ',p.presetfiles{c},'...'));
    
    % import file
    pushbutton_simImpPrm_Callback({p.annexpth,p.presetfiles{c}},[],h_fig);
    
    % update data
    ok = pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
    if ~ok
        pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);
    end
    
    % export log file
    set_S_fileExport(expopt,h_fig);
    pushbutton_exportSim_Callback({p.dumpdir,sprintf('mol_preset_%i',c)},[],...
        h_fig);
end
pushbutton_simRemPrm_Callback(h.pushbutton_simRemPrm,[],h_fig);

% set interface defaults
setDefault_S(h_fig,p);

% test photobleaching
disp(cat(2,prefix,'test photobleaching...'));
pb = ~p.bleach;
set_S_photobleaching(pb,p.t_bleach,h_fig);
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);
set_S_fileExport(expopt,h_fig);
pushbutton_exportSim_Callback({p.dumpdir,'mol_bleach'},[],h_fig);

