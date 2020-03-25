function routinetest_HA_statePopulations(h_fig,p,prefix)
% routinetest_HA_stateConfiguration(h_fig,p,prefix)
%
% Tests calculation of state populations by Gaussian fitting, thresholding and bootstrapping
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

setDefault_HA(h_fig,p);

h = guidata(h_fig);

pushbutton_thm_export_Callback(h.pushbutton_thm_export,[],h_fig);
pushbutton_thm_saveProj_Callback({p.dumpdir,p.exp_pop},[],h_fig)