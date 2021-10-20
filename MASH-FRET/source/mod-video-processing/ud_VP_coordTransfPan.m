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
curr = p.proj{proj}.VP.curr;

% set transformation type
set(h.popupmenu_trType,'value',curr.gen_crd{3}{3}{2});

% set files
set(h.edit_coordFile, 'String', curr.gen_crd{3}{1}{2});
set(h.edit_refCoord_file, 'String', curr.gen_crd{3}{2}{2});
set(h.edit_tr_file, 'String', curr.gen_crd{3}{3}{3});