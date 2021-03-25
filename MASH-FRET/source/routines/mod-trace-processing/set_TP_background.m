function set_TP_background(meth,prm,apply,h_fig)
% set_TP_background(meth,prm,apply,h_fig)
%
% Set background estimator to proper settings
%
% meth: index of background estimation method in list
% prm: [nMeth-by-6] method parameters as set in getDefault_TP
% apply: (1) subtract background, (0) otherwise
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_trBgCorr,'value',meth);
popupmenu_trBgCorr_Callback(h.popupmenu_trBgCorr,[],h_fig);

if sum(meth==(3:7))
    set(h.edit_trBgCorrParam_01,'string',num2str(prm(1)));
    edit_trBgCorrParam_01_Callback(h.edit_trBgCorrParam_01,[],h_fig);
end

set(h.edit_subImg_dim,'string',num2str(prm(2)));
edit_subImg_dim_Callback(h.edit_subImg_dim,[],h_fig);

if meth==1
    set(h.edit_trBgCorr_bgInt,'string',num2str(prm(3)));
    edit_trBgCorr_bgInt_Callback(h.edit_trBgCorr_bgInt,[],h_fig);
end

if meth==6
    set(h.checkbox_autoDark,'value',prm(6));
    checkbox_autoDark_Callback(h.checkbox_autoDark,[],h_fig);
    if ~prm(6)
        set(h.edit_xDark,'string',num2str(prm(4)));
        edit_xDark_Callback(h.edit_xDark,[],h_fig);

        set(h.edit_yDark,'string',num2str(prm(5)));
        edit_yDark_Callback(h.edit_yDark,[],h_fig);
    end
end

set(h.checkbox_trBgCorr,'value',apply);
checkbox_trBgCorr_Callback(h.checkbox_trBgCorr,[],h_fig);


