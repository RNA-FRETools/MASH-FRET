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
expprm = p.proj{proj}.sim.curr.exp;

% set file export options
set(h.checkbox_simParam, 'Value', expprm{1}(1));
set(h.checkbox_procTraces, 'Value', expprm{1}(2));
set(h.checkbox_traces, 'Value', expprm{1}(3));
set(h.checkbox_dt, 'Value', expprm{1}(4));
set(h.checkbox_movie, 'Value', expprm{1}(5));
set(h.checkbox_avi, 'Value', expprm{1}(6));
set(h.checkbox_expCoord, 'Value', expprm{1}(7));

% set exported intensity units
if strcmp(expprm{2}, 'photon')
    set(h.popupmenu_opUnits, 'Value', 1);
else
    set(h.popupmenu_opUnits, 'Value', 2);
end

