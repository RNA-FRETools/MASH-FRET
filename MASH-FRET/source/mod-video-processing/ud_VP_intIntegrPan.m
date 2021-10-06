function ud_VP_intIntegrPan(h_fig)
% ud_VP_intIntegrPan
%
% Set panel "Intensity integration" in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_VP_intensityIntegration,h)
    return
end

% collect experiemnt settings and processing parameters
proj = p.curr_proj;
prm = p.proj{proj}.VP;
isMov = p.proj{proj}.is_movie;

% set parameters
set(h.edit_itg_coordFile, 'String', prm.coordItg_file);
if isMov
    if isfield(h.movie, 'file')
        set(h.edit_movItg, 'String', h.movie.file);
    end
end
set(h.edit_TTgen_dim, 'String', num2str(prm.itg_dim));
set(h.edit_intNpix, 'String', num2str(prm.itg_n));
set(h.checkbox_meanVal, 'Value', prm.itg_ave);


