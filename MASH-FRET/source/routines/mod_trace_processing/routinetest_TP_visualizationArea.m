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

% test graph export
disp(cat(2,prefix,'test graph export and zoom reset...'));
set(h_fig,'CurrentAxes',h.axes_bottom);
exportAxes({[p.dumpdir,filesep,p.exp_axesBot]},[],h_fig);

set(h_fig,'CurrentAxes',h.axes_bottomRight);
exportAxes({[p.dumpdir,filesep,p.exp_axesBotRight]},[],h_fig);

set(h_fig,'CurrentAxes',h.axes_top);
exportAxes({[p.dumpdir,filesep,p.exp_axesTop]},[],h_fig);

set(h_fig,'CurrentAxes',h.axes_topRight);
exportAxes({[p.dumpdir,filesep,p.exp_axesTopRight]},[],h_fig);

for chan = 1:numel(h.axes_subImg)
    set(h_fig,'CurrentAxes',h.axes_subImg(chan));
    exportAxes({[p.dumpdir,filesep,sprintf(p.exp_axesImg,chan)]},[],h_fig);
end

% test zoom reset
ud_zoom([],[],'reset',h_fig);

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
