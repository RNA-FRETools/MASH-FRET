function ud_VP_coordTransfPan(h_fig)
% ud_VP_coordTransfPan(h_fig)
%
% Set panel "Coordinates transformation" in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% set all uicontrol enabled
setProp(h.uipanel_VP_coordinatesTransformation,'enable','on');

% reset edit fields background color
set([h.edit_refCoord_file,h.edit_tr_file,h.edit_coordFile],...
    'backgroundcolor',[1,1,1]);

% set files
set(h.edit_refCoord_file, 'String', p.trsf_coordRef_file);
set(h.edit_tr_file, 'String', p.trsf_tr_file);
set(h.edit_coordFile, 'String', p.coordMol_file);