function set_HA_statePop(methPrm,gaussPrm,threshPrm,h_fig)
% set_HA_statePop(methPrm,gaussPrm,threshPrm,h_fig)
%
% Set panel State population to proper settings
%
% methPrm: [1-by-4] method settings as defined in getDefault_HA.m
% gaussPrm: [3-by-3-by-J] Gaussian fitting parameters (row-wise: amplitude, mean, FWHM; column-wise: min., start, max.)
% threshPrm: [1-by-(J-1)] thresholds 
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

switch methPrm(1)
    case 1
        set(h.radiobutton_thm_gaussFit,'value',1);
        radiobutton_thm_gaussFit_Callback(h.radiobutton_thm_gaussFit,[],...
            h_fig);
        
        set(h.edit_thm_nGaussFit,'string',num2str(gaussPrm{1}));
        edit_thm_nGaussFit_Callback(h.edit_thm_nGaussFit,[],h_fig);
        
        for j = 1:gaussPrm{1}
            set(h.popupmenu_thm_gaussNb,'value',j);
            popupmenu_thm_gaussNb_Callback(h.popupmenu_thm_gaussNb,[],...
                h_fig);

            set(h.edit_thm_ampLow,'string',num2str(gaussPrm{2}(1,1,j)));
            edit_thm_ampLow_Callback(h.edit_thm_ampLow,[],h_fig);

            set(h.edit_thm_ampStart,'string',num2str(gaussPrm{2}(1,2,j)));
            edit_thm_ampStart_Callback(h.edit_thm_ampStart,[],h_fig);

            set(h.edit_thm_ampUp,'string',num2str(gaussPrm{2}(1,3,j)));
            edit_thm_ampUp_Callback(h.edit_thm_ampUp,[],h_fig);

            set(h.edit_thm_centreLow,'string',num2str(gaussPrm{2}(2,1,j)));
            edit_thm_centreLow_Callback(h.edit_thm_centreLow,[],h_fig);

            set(h.edit_thm_centreStart,'string',...
                num2str(gaussPrm{2}(2,2,j)));
            edit_thm_centreStart_Callback(h.edit_thm_centreStart,[],h_fig);

            set(h.edit_thm_centreUp,'string',num2str(gaussPrm{2}(2,3,j)));
            edit_thm_centreUp_Callback(h.edit_thm_centreUp,[],h_fig);

            set(h.edit_thm_fwhmLow,'string',num2str(gaussPrm{2}(3,1,j)));
            edit_thm_fwhmLow_Callback(h.edit_thm_fwhmLow,[],h_fig);

            set(h.edit_thm_fwhmStart,'string',num2str(gaussPrm{2}(3,2,j)));
            edit_thm_fwhmStart_Callback(h.edit_thm_fwhmStart,[],h_fig);

            set(h.edit_thm_fwhmUp,'string',num2str(gaussPrm{2}(3,3,j)));
            edit_thm_fwhmUp_Callback(h.edit_thm_fwhmUp,[],h_fig);
        end
        
    case 2
        set(h.radiobutton_thm_thresh,'value',1);
        radiobutton_thm_thresh_Callback(h.radiobutton_thm_thresh,[],h_fig);
        
        set(h.edit_thm_threshNb,'string',num2str(threshPrm{1}));
        edit_thm_threshNb_Callback(h.edit_thm_threshNb,[],h_fig);
        
        for thresh = 1:threshPrm{1}
            set(h.popupmenu_thm_thresh,'value',thresh);
            popupmenu_thm_thresh_Callback(h.popupmenu_thm_thresh,[],h_fig);
            
            set(h.edit_thm_threshVal,'string',...
                num2str(threshPrm{2}(thresh)));
            edit_thm_threshVal_Callback(h.edit_thm_threshVal,[],h_fig);
        end
end

set(h.checkbox_thm_BS,'value',methPrm(2));
checkbox_thm_BS_Callback(h.checkbox_thm_BS,[],h_fig);
if methPrm(2)
    set(h.edit_thm_nSpl,'string',num2str(methPrm(3)));
    edit_thm_nSpl_Callback(h.edit_thm_nSpl,[],h_fig);

    set(h.checkbox_thm_weight,'value',methPrm(4));
    checkbox_thm_weight_Callback(h.checkbox_thm_weight,[],h_fig);
end
