function routinetest_TA_projectManagementArea(h_fig,p,prefix)
% routinetest_TA_projectManagementArea(h_fig,p,prefix)
%
% Tests project import/export
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end

% test intensity import for different number of channels and lasers
disp(cat(2,prefix,'test trace import for different number of channels ',...
    'and lasers...'));
for nL = 1:p.nL_max
    p.nL = nL;
    for nChan = p.nChan_min:p.nChan_max
        p.nChan = nChan;

        % test ASCII files import 
        disp(cat(2,prefix,'>> import data set ',p.es{nChan,nL}.imp.tdir));
        routinetest_TA_createProj(p,h_fig,[prefix,'>> >> ']);
        
        % switch through data
        nDat = numel(get(h.popupmenu_TDPdataType,'string'));
        for dat = 1:nDat
            set(h.popupmenu_TDPdataType,'value',dat);
            popupmenu_TDPdataType_Callback(h.popupmenu_TDPdataType,[],...
                h_fig);
        end

        % save project
        pushbutton_saveProj_Callback({p.dumpdir,p.exp_ascii2mash{nChan,nL}},...
            [],h_fig);
    end
end
p.nChan = p.nChan_def;
p.nL = p.nL_def;

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end

