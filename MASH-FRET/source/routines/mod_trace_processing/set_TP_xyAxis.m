function set_TP_xyAxis(fixX0,x0,clipX,fixY,y,h_fig)
% sset_TP_xyAxis(fixX0,x0,clipX,fixY,y,h_fig)
%
% Set x- and y-axis parameters to proper values
%
% fixX0: (1) to maintain current starting point for all molecules, (0) otherwise
% x0: x-axis starting point
% clipX: (1) to clip axis bounds to cutoff, (0) otherwise
% fixY: (1) to maintain intensity limits for all molecules, (0) to adjust
%       automatically
% y: [1-by-2] lower and upper limits of intensity axis
% h_fig: handle to main figure

h = guidata(h_fig);

% set intensity axis
set(h.checkbox_plot_holdint,'value',fixY);
checkbox_plot_holdint_Callback(h.checkbox_plot_holdint,[],h_fig);
if fixY
    set(h.edit_plot_minint,'string',num2str(y(1)));
    edit_plot_minint_Callback(h.edit_plot_minint,[],h_fig);
    set(h.edit_plot_maxint,'string',num2str(y(2)));
    edit_plot_maxint_Callback(h.edit_plot_maxint,[],h_fig);
end

% set time axis
set(h.checkbox_photobl_fixStart,'value',fixX0);
checkbox_photobl_fixStart_Callback(h.checkbox_photobl_fixStart,[],h_fig);
if fixX0
    set(h.edit_photobl_start,'string',num2str(x0));
    edit_photobl_start_Callback(h.edit_photobl_start,[],h_fig);
end
set(h.checkbox_cutOff,'value',clipX);
checkbox_cutOff_Callback(h.checkbox_cutOff,[],h_fig);

