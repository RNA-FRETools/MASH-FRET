function ud_VP_molCoordPan(h_fig)
% ud_VP_molCoordPan(h_fig)
%
% Set panel Molecule coordinates to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_VP_moleculeCoordinates,h)
    return
end

% collect processing parameters
proj = p.curr_proj;
prm = p.proj{proj}.VP;

% set average image
set(h.edit_aveImg_iv, 'String', num2str(prm.ave_iv));
set(h.edit_aveImg_start, 'String', num2str(prm.ave_start));
set(h.edit_aveImg_end, 'String', num2str(prm.ave_stop));

% set spot finder
ud_VP_sfPan(h_fig);

% set coordinates transformation
ud_VP_coordTransfPan(h_fig);


