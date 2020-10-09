function ud_VP_expSetPan(h_fig)
% ud_VP_expSetPan(h_fig)
%
% Set panel "Experiment settings" in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% set all uicontrol enabled
setProp(h.uipanel_VP_experimentSettings,'enable','on');

% reset edit fields background color
set([h.edit_nChannel,h.edit_nLasers,h.edit_wavelength,h.edit_rate],...
    'backgroundcolor',[1,1,1]);

% collect processing parameters
nC = p.nChan;
nL = p.itg_nLasers;

% collect video parameters
isMov = isfield(h,'movie');

% set frame rate
if isMov
    if isfield(h.movie,'cyctime')
        set(h.edit_rate, 'String', num2str(p.rate));
    end
end

% set channels
set(h.edit_nChannel, 'String', num2str(nC));

% set lasers
set(h.edit_nLasers, 'String', num2str(nL));
laser = get(h.popupmenu_TTgen_lasers, 'Value');
if laser>nL
    laser = nL;
end
set(h.popupmenu_TTgen_lasers, 'Value', laser, 'String', ...
    cellstr(num2str((1:nL)')));
set(h.edit_wavelength, 'String', num2str(p.itg_wl(laser)));

