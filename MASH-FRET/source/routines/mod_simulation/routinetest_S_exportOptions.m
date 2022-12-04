function routinetest_S_exportOptions(h_fig,p,prefix)
% routinetest_S_exportOptions(h_fig,p,prefix)
%
% Tests file export options, exported intensity units
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
h_but = getHandlePanelExpandButton(h.uipanel_S_exportOptions,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% test file export options
disp(cat(2,prefix,'test file export options...'));
defopts = [p.mat p.sira p.avi p.txt p.dt p.log p.coord];
str_ext = {'.mat','.sira','.avi','.txt','.dt','.log','.coord'};
nOpt = size(defopts,2);
for opt = 1:nOpt
    if ~defopts(opt)
        disp(cat(2,prefix,'export "',str_ext{opt},'" file...'));
        opts = false(1,nOpt);
        opts(opt) = true;
        set_S_fileExport(opts,h_fig);
        ok = pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
        if ~ok
            pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);
        end
        pushbutton_exportSim_Callback({p.dumpdir,'expopt_file'},[],h_fig);
    end
end

% set interface defaults
setDefault_S(h_fig,p);

% generate state sequences with defaults
disp(cat(2,prefix,'test generation of state sequences...'));
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% test intensity units
disp(cat(2,prefix,'test exported intensity units...'));
if p.un_out==1
    un = 2;
else
    un = 1;
end
set(h.popupmenu_opUnits,'value',un);
popupmenu_opUnits_Callback(h.popupmenu_opUnits,[],h_fig);
ok = pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
if ~ok
    pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);
end
set_S_fileExport(expopt,h_fig);
pushbutton_exportSim_Callback({p.dumpdir,'expopt_units'}, [], h_fig);
