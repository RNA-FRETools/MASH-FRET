function routinetest_VP_intensityIntegration(h_fig,p,prefix)
% routinetest_VP_intensityIntegration(h_fig,p,prefix)
%
% Tests trace building and export for different file formats and various combinations of channels and lasers
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% collect interface parameters
h = guidata(h_fig);

setDefault_VP(h_fig,p,prefix);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_VP_intensityIntegration,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

nVid = numel(p.es{p.nChan,p.nL}.imp.vfile);

% set import options
impOpt = {reshape(1:(2*p.nChan),[2,p.nChan])',1};
set_VP_impIntgrOpt(impOpt,h.pushbutton_TTgen_loadOpt,h_fig);

% import coordinates
if nVid==1
    crd_file = p.coord_file{p.nChan};
else
    [~,name,ext] = fileparts(p.coord_file{p.nChan});
    crd_file = [name,'_sglchan',ext];
end
disp(cat(2,prefix,'>> import coordinates from ',crd_file,'...'));
pushbutton_TTgen_loadCoord_Callback({p.annexpth,crd_file},[],h_fig);

% test intensity-time traces creation
disp([prefix,'test calculations of time traces...']);
pushbutton_TTgen_create_Callback(h.pushbutton_TTgen_create,[],h_fig);

% test file export
disp([prefix,'test export of time traces...']);
routinetest_VP_traceExport(h_fig,p,[prefix,'>> ']);

