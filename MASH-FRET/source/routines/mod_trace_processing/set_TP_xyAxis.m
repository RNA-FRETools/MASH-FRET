function set_TP_xyAxis(fixX0,x0,h_fig)
% sset_TP_xyAxis(pfixX0,x0,h_fig)
%
% Set x- and y-axis parameters to proper values
%
% fixX0: (1) to maintain current starting point for all molecules, (0) otherwise
% x0: x-axis starting point
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.checkbox_photobl_fixStart,'value',fixX0);
checkbox_photobl_fixStart_Callback(h.checkbox_photobl_fixStart,[],h_fig);
if fixX0
    set(h.edit_photobl_start,'string',num2str(x0));
    edit_photobl_start_Callback(h.edit_photobl_start,[],h_fig);
end

