function set_TP_xyAxis(perSec,perPix,inSec,fixX0,x0,h_fig)
% sset_TP_xyAxis(inSec,fixX0,x0,h_fig)
%
% Set x- and y-axis parameters to proper values
%
% perSec: (1) to display intensities in counts/second, (0) /frame
% perPix: (1) to display intensities in counts/pixel, (0) otherwise
% inSec: (1) to display x-data in second, (0) in frames
% fixX0: (1) to maintain current starting point for all molecules, (0) otherwise
% x0: x-axis starting point
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.checkbox_ttPerSec,'value',perSec);
checkbox_ttPerSec_Callback(h.checkbox_ttPerSec,[],h_fig);

set(h.checkbox_ttAveInt,'value',perPix);
checkbox_ttAveInt_Callback(h.checkbox_ttAveInt,[],h_fig);

set(h.checkbox_photobl_fixStart,'value',fixX0);
checkbox_photobl_fixStart_Callback(h.checkbox_photobl_fixStart,[],h_fig);
if fixX0
    set(h.edit_photobl_start,'string',num2str(x0));
    edit_photobl_start_Callback(h.edit_photobl_start,[],h_fig);
end

set(h.checkbox_photobl_insec,'value',inSec);
checkbox_photobl_insec_Callback(h.checkbox_photobl_insec,[],h_fig);
