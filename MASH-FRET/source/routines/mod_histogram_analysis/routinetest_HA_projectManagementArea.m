function routinetest_HA_projectManagementArea(h_fig,p,prefix)
% routinetest_HA_projectManagementArea(h_fig,p,prefix)
%
% Tests project import/export
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end

% test histogram import
disp(cat(2,prefix,'test histogram import...'));

% test ASCII files import 
disp(cat(2,prefix,'>> import histogram from file ',...
	p.es{p.nChan,p.nL}.imp.histfile));
routinetest_HA_createProj(p,h_fig,[prefix,'>> >> ']);

% save project
pushbutton_saveProj_Callback({p.dumpdir,p.exp_ascii2mash},...
    [],h_fig);

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end

