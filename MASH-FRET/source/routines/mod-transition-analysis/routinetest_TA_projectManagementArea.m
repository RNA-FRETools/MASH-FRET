function routinetest_TA_projectManagementArea(h_fig,p,prefix)
% routinetest_TA_projectManagementArea(h_fig,p,prefix)
%
% Tests project import/export
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

setDefault_TA(h_fig,p);
ptp = getDefault_TP;

% empty project list
nProj = numel(get(h.listbox_TDPprojList,'string'));
proj = nProj;
while proj>0
    set(h.listbox_TDPprojList,'value',proj);
    listbox_TDPprojList_Callback(h.listbox_TDPprojList,[],h_fig);
    pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
    proj = proj-1;
end

% test project import for different number of channels and lasers
disp(cat(2,prefix,'test trace import for different number of channels ',...
    'and lasers...'));
for nL = 1:ptp.nL_max
    for nChan = 1:ptp.nChan_max
        % test .mash file import 
        disp(cat(2,prefix,'>> import file ',ptp.mash_files{nL,nChan}));
        pushbutton_TDPaddProj_Callback(...
            {ptp.annexpth,ptp.mash_files{nL,nChan}},[],h_fig);
    end
end

% test import of ASCII files for different number of FRET pairs
for nL = 1:p.nL_max
    for nChan = p.nChan_min:p.nChan_max
        % import 
        disp(cat(2,prefix,'>> import data set ',p.ascii_dir{nL,nChan}));
        set_TP_asciiImpOpt(p.asciiOpt{nL,nChan},h_fig);
        pushbutton_TDPaddProj_Callback({...
            [p.annexpth,filesep,p.ascii_dir{nL,nChan}],...
            p.ascii_files{nL,nChan}},[],h_fig);
        
        % switch through data
        nDat = numel(get(h.popupmenu_TDPdataType,'string'));
        for dat = 1:nDat
            set(h.popupmenu_TDPdataType,'value',dat);
            popupmenu_TDPdataType_Callback(h.popupmenu_TDPdataType,[],h_fig);
        end
        
        % save project
        pushbutton_TDPsaveProj_Callback(...
            {p.dumpdir,p.exp_ascii2mash{nL,nChan}},[],h_fig);
    end
end

% empty project list
nProj = numel(get(h.listbox_TDPprojList,'string'));
proj = nProj;
while proj>0
    set(h.listbox_TDPprojList,'value',proj);
    listbox_TDPprojList_Callback(h.listbox_TDPprojList,[],h_fig);
    pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
    proj = proj-1;
end

