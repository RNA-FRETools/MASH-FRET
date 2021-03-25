function ud_S_expOptPan(h_fig)
% ud_S_expOptPan(h_fig)
%
% Set panel Export options to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param.sim;

% make elements invisible if panel is collapsed
h_pan = h.uipanel_S_exportOptions;
if isPanelOpen(h_pan)==1
    setProp(get(h_pan,'children'),'visible','off');
    return
else
    setProp(get(h_pan,'children'),'visible','on');
end

% set all controls on-enabled
setProp(get(h_pan,'children'),'enable','on');

% set file export options
set(h.checkbox_simParam, 'Value', p.export_param);
set(h.checkbox_traces, 'Value', p.export_traces);
set(h.checkbox_movie, 'Value', p.export_movie);
set(h.checkbox_avi, 'Value', p.export_avi);
set(h.checkbox_procTraces, 'Value', p.export_procTraces);
set(h.checkbox_dt, 'Value', p.export_dt);
set(h.checkbox_expCoord, 'Value', p.export_coord);

% set exported intensity units
if strcmp(p.intOpUnits, 'photon')
    set(h.popupmenu_opUnits, 'Value', 1);
else
    set(h.popupmenu_opUnits, 'Value', 2);
end

