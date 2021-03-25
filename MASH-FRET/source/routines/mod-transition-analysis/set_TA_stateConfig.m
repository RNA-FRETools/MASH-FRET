function set_TA_stateConfig(meth,prm,clstConfig,clstStart,h_fig)
% set_TA_stateConfig(meth,prm,clstConfig,clstStart,h_fig)
%
% Set state configuration settings
%
% meth: index in list of clustering method
% prm: [1-by-4] method settings as set by getDef_fidJ
% clstConfig: [1-by-4] cluster configuration parameters as set by getDef_fidJ
% clstStart: [J-by-2] starting guess for cluster centers ans radii
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_TA_clstMeth,'value',meth);
popupmenu_TA_clstMeth_Callback(h.popupmenu_TA_clstMeth,[],h_fig);

set(h.edit_TDPnStates,'string',num2str(prm(1)));
edit_TDPnStates_Callback(h.edit_TDPnStates,[],h_fig);

if sum(meth==[1,2])
    set(h.edit_TDPmaxiter,'string',num2str(prm(2)));
    edit_TDPmaxiter_Callback(h.edit_TDPmaxiter,[],h_fig);
end

set(h.checkbox_TDPboba,'value',prm(3));
checkbox_TDPboba_Callback(h.checkbox_TDPboba,[],h_fig);

if prm(3)
    set(h.edit_TDPnSpl,'string',num2str(prm(4)));
    edit_TDPnSpl_Callback(h.edit_TDPnSpl,[],h_fig);
end

set(h.popupmenu_TA_clstMat,'value',clstConfig(1));
popupmenu_TA_clstMat_Callback(h.popupmenu_TA_clstMat,[],h_fig);

if clstConfig(1)==1
    set(h.checkbox_TA_clstDiag,'value',clstConfig(2));
    checkbox_TA_clstDiag_Callback(h.checkbox_TA_clstDiag,[],h_fig);
end

if meth==2
    set(h.popupmenu_TDPlike,'value',clstConfig(3));
    popupmenu_TDPlike_Callback(h.popupmenu_TDPlike,[],h_fig);
else
    J = numel(get(h.popupmenu_TDPstate,'string'));
    for j = 1:J
        set(h.popupmenu_TDPstate,'value',j);
        popupmenu_TDPstate_Callback(h.popupmenu_TDPstate,[],h_fig);

        set(h.edit_TDPiniValX,'string',num2str(clstStart(j,1)));
        edit_TDPiniVal_Callback(h.edit_TDPiniValX,[],1,h_fig);

        set(h.edit_TDPradiusX,'string',num2str(clstStart(j,2)));
        edit_TDPradius_Callback(h.edit_TDPradiusX,[],1,h_fig);

        if clstConfig(1)>1
            set(h.edit_TDPiniValY,'string',num2str(clstStart(j,3)));
            edit_TDPiniVal_Callback(h.edit_TDPiniValY,[],2,h_fig);

            set(h.edit_TDPradiusY,'string',num2str(clstStart(j,4)));
            edit_TDPradius_Callback(h.edit_TDPradiusY,[],2,h_fig);
        end
    end
end

h_tgl = [h.togglebutton_TDPshape1,h.togglebutton_TDPshape2,...
    h.togglebutton_TDPshape3,h.togglebutton_TDPshape4];

set(h_tgl(clstConfig(4)),'value',1)
togglebutton_TDPshape_Callback(h.togglebutton_TDPshape1,[],clstConfig(4),...
    h_fig);




