function ud_extendedPanel(h_but,h_fig)
% ud_extendedPanel(h_but,h_fig)
%
% Set extendable panel component properties to proper values
%
% h_but: row vector of handles to extend/collapse buttons
% h_fig: handle to main figure

h = guidata(h_fig);

for b = h_but
    switch b.UserData{1}.Parent
        case h.uipanel_S
            ud_S_panels(h_fig);
        case h.uipanel_VP
            ud_VP_panels(h_fig);
        case h.uipanel_TP
            ud_TP_panels(h_fig);
        case h.uipanel_HA
            ud_HA_panels(h_fig);
        case h.uipanel_TA
            ud_TA_panels(h_fig);
        otherwise
            disp('ud_extendedPanel: unknown extendable panel.');
    end

%     switch b.UserData{1}
%         case h.uipanel_S_videoParameters
%             ud_S_vidParamPan(h_fig);
%         case h.uipanel_S_molecules
%             ud_S_moleculesPan(h_fig);
%         case h.uipanel_S_experimentalSetup
%             ud_S_expSetupPan(h_fig);
%         case h.uipanel_S_exportOptions
%             ud_S_expOptPan(h_fig);
% 
%         case h.uipanel_VP_experimentSettings
%             ud_VP_expSetPan(h_fig);
%         case h.uipanel_VP_editAndExportVideo
%             ud_VP_edExpVidPan(h_fig);
%         case h.uipanel_VP_moleculeCoordinates
%             ud_VP_molCoordPan(h_fig);
%         case h.uipanel_VP_intensityIntegration
%             ud_VP_intIntegrPan(h_fig);
% 
%         case h.uipanel_TP_sampleManagement
%             ud_trSetTbl(h_fig);
%         case h.uipanel_TP_plot
%             ud_plot(h_fig);
%         case h.uipanel_TP_subImages
%             ud_subImg(h_fig);
%         case h.uipanel_TP_backgroundCorrection
%             ud_ttBg(h_fig);
%         case h.uipanel_TP_crossTalks
%             ud_cross(h_fig);
%         case h.uipanel_TP_denoising
%             ud_denoising(h_fig);
%         case h.uipanel_TP_photobleaching
%             ud_bleach(h_fig);
%         case h.uipanel_TP_factorCorrections
%             ud_factors(h_fig);
%         case h.uipanel_TP_findStates
%             ud_DTA(h_fig);
% 
%         case h.uipanel_HA_histogramAndPlot
%             ud_thmPlot(h_fig);
%         case h.uipanel_HA_stateConfiguration
%             ud_HA_stateConfig(h_fig);
%         case h.uipanel_HA_statePopulations
%             ud_HA_statePop(h_fig);
% 
%         case h.uipanel_TA_transitionDensityPlot
%             ud_TDPplot(h_fig);
%         case h.uipanel_TA_stateConfiguration
%             ud_TDPmdlSlct(h_fig);
%         case h.uipanel_TA_dtHistograms
%             ud_kinFit(h_fig);
%         case h.uipanel_TA_kineticModel
%             ud_kinMdl(h_fig)
% 
%         otherwise
%             disp('ud_extendedPanel: unknown extendable panel.');
%     end
end
