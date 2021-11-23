function routinetest_TP_findStates(h_fig,p,prefix)
% routinetest_TP_findStates(h_fig,p,prefix)
%
% Tests different states finding algorithm and post-processing methods
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

% open default project
disp(cat(2,prefix,'import file ',p.mash_files{p.nL,p.nChan}));
pushbutton_openProj_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},...
    [],h_fig);

% set default parameters
setDefault_TP(h_fig,p);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_TP_findStates,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

set_TP_findStates(p.fsMeth,3,p.fsPrm,p.fsThresh,p.nChan,p.nL,h_fig);
nDat = numel(get(h.popupmenu_TP_states_data,'string'));
fsPrm = repmat(p.fsPrm,1,1,nDat);
fsThresh = repmat(p.fsThresh,1,1,nDat);

str_meth = get(h.popupmenu_TP_states_method,'string');
str_trace = get(h.popupmenu_TP_states_applyTo,'string');
nMeth = numel(str_meth);
nTraces = numel(str_trace);
for meth = 1:nMeth
    for trace = 1:nTraces
        disp(cat(2,prefix,'test method ',str_meth{meth},' applied to ',...
            str_trace{trace},' traces...'));

        set_TP_findStates(meth,trace,fsPrm,fsThresh,p.nChan,p.nL,h_fig);
        
        if meth==3 && trace>1 % 2D-vbFRET
            continue
        end
        
        pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

        % test display of results
        J = numel(get(h.popupmenu_TP_states_index,'string'));
        for j = 1:J
            set(h.popupmenu_TP_states_index,'value',j);
            popupmenu_TP_states_index_Callback(h.popupmenu_TP_states_index,...
                [],h_fig);
        end
    end
end

disp(cat(2,prefix,'test post-processing method "refine"...'));
fsPrm = p.fsPrm;
fsPrm(:,5,:) = true;
set_TP_findStates(meth,trace,fsPrm,fsThresh,p.nChan,p.nL,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
        
disp(cat(2,prefix,'test post-processing method "binning"...'));
fsPrm = p.fsPrm;
fsPrm(:,6,:) = true;
set_TP_findStates(meth,trace,fsPrm,fsThresh,p.nChan,p.nL,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
        
disp(cat(2,prefix,'test post-processing method "deblurr"...'));
fsPrm = p.fsPrm;
fsPrm(:,7,:) = true;
set_TP_findStates(meth,trace,fsPrm,fsThresh,p.nChan,p.nL,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

disp(cat(2,prefix,'test post-processing method "Adjust to data"...'));
fsPrm = p.fsPrm;
fsPrm(:,8,:) = true;
set_TP_findStates(meth,trace,fsPrm,fsThresh,p.nChan,p.nL,h_fig);
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

pushbutton_applyAll_DTA_Callback(h.pushbutton_applyAll_DTA,[],h_fig);
pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
