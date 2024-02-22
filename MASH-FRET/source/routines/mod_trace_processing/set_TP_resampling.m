function set_TP_resampling(splt,h_fig)
% set_TP_resampling(splt,h_fig)
%
% Set Sampling detection to proper settings
%
% splt: trajectory sampling time
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

% set sampling time
set(h.edit_TP_sampling_time,'string',num2str(splt));
edit_TP_sampling_time_Callback(h.edit_TP_sampling_time,[],h_fig);


