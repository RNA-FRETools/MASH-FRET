function routinetest_HA_projectManagementArea(h_fig,p,prefix)
% routinetest_HA_projectManagementArea(h_fig,p,prefix)
%
% Tests project import/export
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

setDefault_HA(h_fig,p);
ptp = getDefault_TP;

% empty project list
nProj = numel(get(h.listbox_thm_projLst,'string'));
proj = nProj;
while proj>0
    set(h.listbox_thm_projLst,'value',proj);
    listbox_thm_projLst_Callback(h.listbox_thm_projLst,[],h_fig);
    pushbutton_thm_rmProj_Callback(h.pushbutton_thm_rmProj,[],h_fig);
    proj = proj-1;
end

% test project import for different number of channels and lasers
disp(cat(2,prefix,'test trace import for different number of channels ',...
    'and lasers...'));
for nL = 1:ptp.nL_max
    for nChan = 1:ptp.nChan_max
        % test .mash file import 
        disp(cat(2,prefix,'>> import file ',ptp.mash_files{nL,nChan}));
        pushbutton_thm_addProj_Callback(...
            {ptp.annexpth,ptp.mash_files{nL,nChan}},[],h_fig);
    end
end

% empty project list
nProj = numel(get(h.listbox_thm_projLst,'string'));
proj = nProj;
while proj>0
    set(h.listbox_thm_projLst,'value',proj);
    listbox_thm_projLst_Callback(h.listbox_thm_projLst,[],h_fig);
    pushbutton_thm_rmProj_Callback(h.pushbutton_thm_rmProj,[],h_fig);
    proj = proj-1;
end
