function routinetest_TP_visualizationArea(h_fig,p,prefix)
% routinetest_TP_visualizationArea(h_fig,p,prefix)
%
% Tests graph export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

% open default project
disp(cat(2,prefix,'import file ',p.mash_files{p.nL,p.nChan}));
pushbutton_openProj_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},...
    [],h_fig);

% set default parameters
setDefault_TP(h_fig,p);

h = guidata(h_fig);

% test graph export and zoom reset
disp(cat(2,prefix,'test graph export and zoom reset...'));
h_axes = getHandleWithPropVal(h.uipanel_TP,'Type','axes');
for ax = 1:numel(h_axes)
    set(h_fig,'CurrentAxes',h_axes(ax));
    exportAxes({[p.dumpdir,filesep,p.exp_axes,'_',num2str(ax)]},[],h_fig);
    ud_zoom([],[],'reset',h_fig);
end

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
