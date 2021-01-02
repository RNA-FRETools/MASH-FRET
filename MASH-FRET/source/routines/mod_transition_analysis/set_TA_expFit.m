function set_TA_expFit(v,expPrm,fitPrm,h_fig)
% set_TA_expFit(v,expPrm,fitPrm,h_fig)
%
% Set Exponential fitting parameters to proper values
%
% v: index of the state to be parametrized
% expPrm: method settings as geenrated by getDef_kinsoft.m
% fitPrm: [3-by-3-by-nExp] bounds and starting guesses for fitting parameters
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

% open fit settings
pushbutton_TA_fitSettings_Callback(h.pushbutton_TA_fitSettings,[],h_fig);
h = guidata(h_fig);
q = guidata(h.figure_TA_fitSettings);

% select state
set(q.popupmenu_TA_slStates,'value',v);
popupmenu_TA_slStates_Callback(q.popupmenu_TA_slStates,[],h_fig);

% set auto/manual setting
set(q.radiobutton_TA_slAuto,'value',expPrm(1));
radiotbutton_TA_slAuto_Callback(q.radiobutton_TA_slAuto,[],h_fig);
if expPrm(1)
    return
end

if expPrm(2)
    set(q.radiobutton_TDPstretch,'value',expPrm(2));
    radiobutton_TDPstretch_Callback(q.radiobutton_TDPstretch,[],h_fig);
    nExp = 1;
else
    set(q.radiobutton_TDPmultExp,'value',true);
    radiobutton_TDPmultExp_Callback(q.radiobutton_TDPmultExp,[],h_fig);

    set(q.edit_TDP_nExp,'string',num2str(expPrm(3)));
    edit_TDP_nExp_Callback(q.edit_TDP_nExp,[],h_fig);
    nExp = expPrm(3);
end

set(q.checkbox_BOBA,'value',expPrm(4));
checkbox_BOBA_Callback(q.checkbox_BOBA,[],h_fig);
if expPrm(4)
    set(q.checkbox_bobaWeight,'value',expPrm(5));
    checkbox_bobaWeight_Callback(q.checkbox_bobaWeight,[],h_fig);

    set(q.edit_TDPbsprm_02,'string',num2str(expPrm(6)));
    edit_TDPbsprm_02_Callback(q.edit_TDPbsprm_02,[],h_fig);
end

for n = 1:nExp
    if ~expPrm(2)
        set(q.popupmenu_TDP_expNum,'value',n);
        popupmenu_TDP_expNum_Callback(q.popupmenu_TDP_expNum,[],h_fig);
    end

    set(q.edit_TDPfit_aLow,'string',num2str(fitPrm(1,1,n)));
    edit_TDPfit_aLow_Callback(q.edit_TDPfit_aLow,[],h_fig);

    set(q.edit_TDPfit_aStart,'string',num2str(fitPrm(1,2,n)));
    edit_TDPfit_aStart_Callback(q.edit_TDPfit_aStart,[],h_fig);

    set(q.edit_TDPfit_aUp,'string',num2str(fitPrm(1,3,n)));
    edit_TDPfit_aUp_Callback(q.edit_TDPfit_aUp,[],h_fig);

    set(q.edit_TDPfit_decLow,'string',num2str(fitPrm(2,1,n)));
    edit_TDPfit_decStart_Callback(q.edit_TDPfit_decLow,[],h_fig);

    set(q.edit_TDPfit_decStart,'string',num2str(fitPrm(2,2,n)));
    edit_TDPfit_decStart_Callback(q.edit_TDPfit_decStart,[],h_fig);

    set(q.edit_TDPfit_decUp,'string',num2str(fitPrm(2,3,n)));
    edit_TDPfit_decUp_Callback(q.edit_TDPfit_decUp,[],h_fig);

    if expPrm(2)
        set(q.edit_TDPfit_betaLow,'string',num2str(fitPrm(3,1,n)));
        edit_TDPfit_betaLow_Callback(q.edit_TDPfit_betaLow,[],h_fig);

        set(q.edit_TDPfit_betaStart,'string',num2str(fitPrm(3,2,n)));
        edit_TDPfit_betaStart_Callback(q.edit_TDPfit_betaStart,[],h_fig);

        set(q.edit_TDPfit_betaUp,'string',num2str(fitPrm(3,3,n)));
        edit_TDPfit_betaUp_Callback(q.edit_TDPfit_betaUp,[],h_fig);
    end
end

close(h.figure_TA_fitSettings);
