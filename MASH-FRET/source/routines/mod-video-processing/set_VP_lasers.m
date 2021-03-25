function set_VP_lasers(nL,wl,h_fig)
% set_VP_lasers(nL,wl,h_fig)
%
% Set laser settings to proper values and update interface parameters
%
% nL: number of lasers
% wl: laser wavelengths
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

% set number of lasers
set(h.edit_nLasers,'string',num2str(nL));
edit_nLasers_Callback(h.edit_nLasers,[],h_fig);

% set laser wavelengths
for l = 1:nL
    set(h.popupmenu_TTgen_lasers,'value',l)
    popupmenu_TTgen_lasers_Callback(h.popupmenu_TTgen_lasers,[],h_fig);
    
    set(h.edit_wavelength,'string',num2str(wl(l)));
    edit_wavelength_Callback(h.edit_wavelength,[],h_fig);
end