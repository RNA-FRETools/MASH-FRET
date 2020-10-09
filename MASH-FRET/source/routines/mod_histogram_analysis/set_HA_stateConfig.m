function set_HA_stateConfig(prm,h_fig)
% set_HA_stateConfig(prm,h_fig)
%
% Set panel State configuration to proper settings
%
% prm: [1-by-3] state configuration settings
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.edit_thm_maxGaussNb,'string',num2str(prm(1)));
edit_thm_maxGaussNb_Callback(h.edit_thm_maxGaussNb,[],h_fig);

switch prm(2)
    case 1
        set(h.radiobutton_thm_penalty,'value',1);
        radiobutton_thm_penalty_Callback(h.radiobutton_thm_penalty,[],...
            h_fig);

        set(h.edit_thm_penalty,'string',num2str(prm(3)));
        edit_thm_penalty_Callback(h.edit_thm_penalty,[],h_fig);
        
    case 2

        set(h.radiobutton_thm_BIC,'value',1);
        radiobutton_thm_BIC_Callback(h.radiobutton_thm_BIC,[],h_fig);
end
