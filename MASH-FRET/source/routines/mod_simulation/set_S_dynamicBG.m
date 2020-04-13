function set_S_dynamicBG(dyn,prm,h_fig)
% set_S_dynamicBG(dyn,dec,a,h_fig)
%
% Set dynamic background parameters to proper values and update interface
%
% dyn: 1 to apply exponentially decaying background, 0 otherwise 
% prm: [1-by-2] time decay constant (in seconds) and multiplication factor for starting background amplitude
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.checkbox_bgExp,'value',dyn);
checkbox_bgExp_Callback(h.checkbox_bgExp,[],h_fig);

if dyn
    set(h.edit_bgExp_cst,'string',num2str(prm(1)));
    edit_bgExp_cst_Callback(h.edit_bgExp_cst,[],h_fig);

    set(h.edit_simAmpBG,'string',num2str(prm(2)));
    edit_simAmpBG_Callback(h.edit_simAmpBG,[],h_fig);
end