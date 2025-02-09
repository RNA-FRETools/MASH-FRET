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
inSec = p.proj{proj}.time_in_sec;
expT = p.proj{proj}.sampling_time;
curr = p.proj{proj}.VP.curr;

% set average image
if inSec
    curr.gen_crd{1}(1) = curr.gen_crd{1}(1)*expT;
    curr.gen_crd{1}(2) = curr.gen_crd{1}(2)*expT;
    curr.gen_crd{1}(3) = curr.gen_crd{1}(3)*expT;
end
set(h.edit_aveImg_start, 'String', num2str(curr.gen_crd{1}(1)));
set(h.edit_aveImg_end, 'String', num2str(curr.gen_crd{1}(2)));
set(h.edit_aveImg_iv, 'String', num2str(curr.gen_crd{1}(3)));

% set spot finder
ud_VP_sfPan(h_fig);

% set coordinates transformation
ud_VP_coordTransfPan(h_fig);


