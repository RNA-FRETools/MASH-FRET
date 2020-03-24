function set_TA_expFit(expPrm,fitPrm,h_fig)
% set_TA_expFit(expPrm,fitPrm,h_fig)
%
% Set Exponential fitting to proper values
%
% expPrm: method settings as geenrated by getDef_kinsoft.m
% fitPrm: [3-by-3-by-nExp] bounds and starting guesses for fitting parameters
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

if expPrm(1)
    set(h.radiobutton_TDPstretch,'value',expPrm(1));
    radiobutton_TDPstretch_Callback(h.radiobutton_TDPstretch,[],h_fig);
    nExp = 1;
else
    set(h.radiobutton_TDPmultExp,'value',true);
    radiobutton_TDPmultExp_Callback(h.radiobutton_TDPmultExp,[],h_fig);

    set(h.edit_TDP_nExp,'string',num2str(expPrm(2)));
    edit_TDP_nExp_Callback(h.edit_TDP_nExp,[],h_fig);
    nExp = expPrm(2);
end

set(h.checkbox_BOBA,'value',expPrm(3));
checkbox_BOBA_Callback(h.checkbox_BOBA,[],h_fig);
if expPrm(3)
    set(h.checkbox_bobaWeight,'value',expPrm(4));
    checkbox_bobaWeight_Callback(h.checkbox_bobaWeight,[],h_fig);

    set(h.edit_TDPbsprm_02,'string',num2str(expPrm(5)));
    edit_TDPbsprm_02_Callback(h.edit_TDPbsprm_02,[],h_fig);
end

for n = 1:nExp
    if ~expPrm(1)
        set(h.popupmenu_TDP_expNum,'value',n);
        popupmenu_TDP_expNum_Callback(h.popupmenu_TDP_expNum,[],h_fig);
    end

    set(h.edit_TDPfit_aLow,'string',num2str(fitPrm(1,1,n)));
    edit_TDPfit_aLow_Callback(h.edit_TDPfit_aLow,[],h_fig);

    set(h.edit_TDPfit_aStart,'string',num2str(fitPrm(1,2,n)));
    edit_TDPfit_aStart_Callback(h.edit_TDPfit_aStart,[],h_fig);

    set(h.edit_TDPfit_aUp,'string',num2str(fitPrm(1,3,n)));
    edit_TDPfit_aUp_Callback(h.edit_TDPfit_aUp,[],h_fig);

    set(h.edit_TDPfit_decLow,'string',num2str(fitPrm(2,1,n)));
    edit_TDPfit_decStart_Callback(h.edit_TDPfit_decLow,[],h_fig);

    set(h.edit_TDPfit_decStart,'string',num2str(fitPrm(2,2,n)));
    edit_TDPfit_decStart_Callback(h.edit_TDPfit_decStart,[],h_fig);

    set(h.edit_TDPfit_decUp,'string',num2str(fitPrm(2,3,n)));
    edit_TDPfit_decUp_Callback(h.edit_TDPfit_decUp,[],h_fig);

    if expPrm(1)
        set(h.edit_TDPfit_betaLow,'string',num2str(fitPrm(3,1,n)));
        edit_TDPfit_betaLow_Callback(h.edit_TDPfit_betaLow,[],h_fig);

        set(h.edit_TDPfit_betaStart,'string',num2str(fitPrm(3,2,n)));
        edit_TDPfit_betaStart_Callback(h.edit_TDPfit_betaStart,[],h_fig);

        set(h.edit_TDPfit_betaUp,'string',num2str(fitPrm(3,3,n)));
        edit_TDPfit_betaUp_Callback(h.edit_TDPfit_betaUp,[],h_fig);
    end
end
