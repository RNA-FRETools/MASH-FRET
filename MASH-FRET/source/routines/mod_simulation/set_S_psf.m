function set_S_psf(psf,psfW,h_fig)
% set_S_psf(psf,psfW,h_fig)
%
% Set PSF parameters to proper values and update interface
%
% psf: 1 to apply PSF convolution, 0 do not convolute
% psfW: [1-by-2] PSF width in donor and acceptor channels (in um)
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.checkbox_convPSF,'value',psf);
checkbox_convPSF_Callback(h.checkbox_convPSF,[],h_fig);

if psf
    set(h.edit_psfW1,'string',num2str(psfW(1)));
    edit_psfW1_Callback(h.edit_psfW1,[],h_fig);
    
    set(h.edit_psfW2,'string',num2str(psfW(2)));
    edit_psfW2_Callback(h.edit_psfW2,[],h_fig);
end
