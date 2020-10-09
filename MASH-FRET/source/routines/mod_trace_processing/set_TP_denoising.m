function set_TP_denoising(meth,prm,apply,h_fig)
% set_TP_denoising(meth,prm,apply,h_fig)
%
% Set denosiing settings to proper values
%
% meth: index of denoising method in list
% prm: [nMeth-by-3] method parameters as set in getDefault_TP
% apply: (1) smooth traces, (0) otherwise
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_denoising,'value',meth);
popupmenu_denoising_Callback(h.popupmenu_denoising,[],h_fig);

set(h.edit_denoiseParam_01,'string',num2str(prm(meth,1)));
edit_denoiseParam_01_Callback(h.edit_denoiseParam_01,[],h_fig);

if meth~=1
    set(h.edit_denoiseParam_02,'string',num2str(prm(meth,2)));
    edit_denoiseParam_02_Callback(h.edit_denoiseParam_02,[],h_fig);

    set(h.edit_denoiseParam_03,'string',num2str(prm(meth,3)));
    edit_denoiseParam_03_Callback(h.edit_denoiseParam_03,[],h_fig);
end

set(h.checkbox_smoothIt,'value',apply);
checkbox_smoothIt_Callback(h.checkbox_smoothIt,[],h_fig);
