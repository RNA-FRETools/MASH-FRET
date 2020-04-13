function ud_VP_intIntegrPan(h_fig)
% ud_VP_intIntegrPan
%
% Set panel "Intensity integration" in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% set all uicontrol enabled
setProp(h.uipanel_VP_intensityIntegration,'enable','on');

% reset edit fields background color
set([h.edit_itg_coordFile,h.edit_movItg,h.edit_TTgen_dim,h.edit_intNpix],...
    'backgroundcolor',[1,1,1]);

% collect video parameters
isMov = isfield(h, 'movie');

% set parameters
set(h.edit_itg_coordFile, 'String', p.coordItg_file);
if isMov
    if isfield(h.movie, 'file')
        set(h.edit_movItg, 'String', h.movie.file);
    end
end
set(h.edit_TTgen_dim, 'String', num2str(p.itg_dim));
set(h.edit_intNpix, 'String', num2str(p.itg_n));
set(h.checkbox_meanVal, 'Value', p.itg_ave);


