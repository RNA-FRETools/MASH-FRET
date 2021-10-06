function ud_VP_coordTransfPan(h_fig)
% ud_VP_coordTransfPan(h_fig)
%
% Set panel "Coordinates transformation" in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_VP_coordinatesTransformation,h)
    return
end

% collect processing parameters
proj = p.curr_proj;
prm = p.proj{proj}.VP;

% set files
set(h.edit_refCoord_file, 'String', prm.trsf_coordRef_file);
set(h.edit_tr_file, 'String', prm.trsf_tr_file);
set(h.edit_coordFile, 'String', prm.coordMol_file);