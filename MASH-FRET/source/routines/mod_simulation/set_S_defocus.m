function set_S_defocus(defocus,prm,h_fig)
% set_S_defocus(defocus,prm,h_fig)
%
% Set defocusing parameters to proper values and update interface
%
% defocus: 1 to apply defocusing, 0 keep original traces
% prm: [1-by-2] defocusing exponential time constant and defocusing initial amplitude
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.checkbox_defocus,'value',defocus);
checkbox_defocus_Callback(h.checkbox_defocus,[],h_fig);

if defocus
    set(h.edit_simzdec,'string',num2str(prm(1)));
    edit_simzdec_Callback(h.edit_simzdec,[],h_fig);
    
    set(h.edit_simz0_A,'string',num2str(prm(2)));
    edit_simz0_A_Callback(h.edit_simz0_A,[],h_fig);
end