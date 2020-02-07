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
        pushbutton_exportSim_Callback({p.dumpdir,'file_opt'}, [], h_fig);
    end
end

% set interface defaults
setDefault_S(h_fig,p);

% generate state sequences with defaults
disp(cat(2,prefix,'test generation of state sequences...'));
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% test intensity units
disp(cat(2,prefix,'test exported intensity units...'));
set_S_fileExport(expopt,h_fig);
pushbutton_exportSim_Callback({p.dumpdir,'units_out'}, [], h_fig);
