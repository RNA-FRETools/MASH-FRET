function ud_S_expOptPan(h_fig)
% ud_S_expOptPan(h_fig)
%
% Set panel Export options to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_S_exportOptions,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
prm = p.proj{proj}.sim;

% set file export options
set(h.checkbox_simParam, 'Value', prm.export_param);
set(h.checkbox_traces, 'Value', prm.export_traces);
set(h.checkbox_movie, 'Value', prm.export_movie);
set(h.checkbox_avi, 'Value', prm.export_avi);
set(h.checkbox_procTraces, 'Value', prm.export_procTraces);
set(h.checkbox_dt, 'Value', prm.export_dt);
set(h.checkbox_expCoord, 'Value', prm.export_coord);

% set exported intensity units
if strcmp(prm.intOpUnits, 'photon')
    set(h.popupmenu_opUnits, 'Value', 1);
else
    set(h.popupmenu_opUnits, 'Value', 2);
end

