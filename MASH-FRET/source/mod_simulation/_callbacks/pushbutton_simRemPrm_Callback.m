function pushbutton_simRemPrm_Callback(obj, evd, h_fig)

% Last update by MH, 19.12.2019
% >> review reset of coordinates in case import is done from ASCII file
%  (only possible if coordinates from preset file could not be imported/
%  were all out-of-video range)
% >> reset PSF factor matrix only if PSF widths were imported from presets
%
% update by MH, 12.12.2019:
% >> update coordinates after removing pre-sets

resetSimPrm(h_fig)

% display potentially new coordinates
h = guidata(h_fig);
setSimCoordTable(h.param.sim,h.uitable_simCoord);

% set GUI to proper values
updateFields(h_fig, 'sim');
