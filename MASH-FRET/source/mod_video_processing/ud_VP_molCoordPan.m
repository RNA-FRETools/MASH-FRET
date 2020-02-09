function ud_VP_molCoordPan(h_fig)
% ud_VP_molCoordPan(h_fig)
%
% Set panel Molecule coordinates to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% set all uicontrol enabled
setProp(h.uipanel_VP_moleculeCoordinates,'enable','on');

% reset edit fields background color
set([h.edit_aveImg_iv,h.edit_aveImg_start,h.edit_aveImg_end],...
    'backgroundcolor',[1,1,1]);

% set average image
set(h.edit_aveImg_iv, 'String', num2str(p.ave_iv));
set(h.edit_aveImg_start, 'String', num2str(p.ave_start));
set(h.edit_aveImg_end, 'String', num2str(p.ave_stop));

% set spot finder
ud_VP_sfPan(h_fig);

% set coordinates transformation
ud_VP_coordTransfPan(h_fig);


