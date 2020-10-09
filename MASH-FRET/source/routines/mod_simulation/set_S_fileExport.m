function set_S_fileExport(prm,h_fig)
% set_S_fileExport(prm,h_fig)
%
% Set file export options to proper values and update interface
%
% prm: [1-by-7] true/false vector to export/not the different type of files following the order: (1) .mat, (2) .sira, (3) .avi, (4) .txt, (5) .dt, (6) .log, (7) .crd
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.checkbox_traces,'value',prm(1));
checkbox_traces_Callback(h.checkbox_traces,[],h_fig);

set(h.checkbox_movie,'value',prm(2));
checkbox_movie_Callback(h.checkbox_movie,[],h_fig);

set(h.checkbox_avi,'value',prm(3));
checkbox_avi_Callback(h.checkbox_avi,[],h_fig);

set(h.checkbox_procTraces,'value',prm(4));
checkbox_procTraces_Callback(h.checkbox_procTraces,[],h_fig);

set(h.checkbox_dt,'value',prm(5));
checkbox_dt_Callback(h.checkbox_dt,[],h_fig);

set(h.checkbox_simParam,'value',prm(6));
checkbox_simParam_Callback(h.checkbox_simParam,[],h_fig);

set(h.checkbox_expCoord,'value',prm(7));
checkbox_expCoord_Callback(h.checkbox_expCoord,[],h_fig);
