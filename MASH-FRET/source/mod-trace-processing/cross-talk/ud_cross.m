function ud_cross(h_fig)

%%
% Last update: 3.4.2019 by MH
% --> change pushbutton string to "Opt." if method photobleaching-based 
%     gamma is chosen, or "Load" if manual
% --> correct control off-enabling when data "none" is selected
%
% update: 29.3.2019 by MH
% --> delete popupmenu_excDirExc and text_dirExc from GUI
% --> adapt display of bleethrough and direct excitation coefficient to new 
%     parameter structure (see project/setDefPrm_traces.m)
%
% update: 28.3.2019 by MH
% --> UI controls for DE coefficients are made visible even if calculation
%     is not possible (one laser data) but are off-enabled in that case,
%     but popupmenu for laser selection is made off-visible.
%
% update: 26.3.2019 by MH
% --> gamma correction checkbox changed to popupmenu
%
% update: 26.4.2018 by FS
% --> update the gamma correction checkbox when changing to different 
%     molecules
%%

h = guidata(h_fig);
p = h.param.ttPr.proj;
if ~isempty(p)
    proj = h.param.ttPr.curr_proj;
    mol = h.param.ttPr.curr_mol(proj);
    curr_exc = p{proj}.fix{3}(1);
    curr_chan = p{proj}.fix{3}(2);
    curr_fret = p{proj}.fix{3}(8);
    p_panel = p{proj}.curr{mol}{5};
    
    curr_btChan = p{proj}.fix{3}(3);
    
    % cancelled by MH, 29.3.2019
%     curr_dirExc = p{proj}.fix{3}(7);
    
    exc = p{proj}.excitations;
    nChan = p{proj}.nb_channel;
    FRET = p{proj}.FRET;
    nFRET = size(FRET,1);
    nExc = numel(exc);
    labels = p{proj}.labels;
    clr = p{proj}.colours;
    
    % added by MH, 29.3.2019
    chanExc = p{proj}.chanExc;
    
    % cancelled by MH, 29.3.2019
%     set(h.popupmenu_corr_exc, 'Value', curr_exc);
    
    % modified by MH, 29.3.2019
%     set(h.popupmenu_corr_chan, 'Value', curr_chan, 'String', ...
%         getStrPop('chan', {labels curr_exc clr{1}}));
    set(h.popupmenu_corr_chan, 'Value', 1, 'String', ...
        getStrPop('chan', {labels curr_exc clr{1}}));
    set(h.popupmenu_corr_chan, 'Value', curr_chan);
    
    set(h.popupmenu_bt, 'Value', 1, 'String', getStrPop('bt_chan', ...
        {labels curr_chan curr_exc clr{1}}));
    set(h.popupmenu_bt, 'Value', curr_btChan);
    
    % cancelled by MH, 29.3.2019
%     set(h.popupmenu_excDirExc, 'Value', 1, 'String', ...
%         getStrPop('dir_exc',{exc curr_exc curr_chan clr{1}}));
    
    set(h.popupmenu_gammaFRET, 'Value', 1, 'String', ...
        getStrPop('corr_gamma', {FRET labels clr}));
    
    % cancelled by MH, 29.3.2019
%     set(h.popupmenu_excDirExc, 'Value', curr_dirExc);
    if nChan > 1
        % modified by MH, 29.3.2019
%         set(h.edit_bt, 'String', ...
%             num2str(p_panel{1}{curr_exc,curr_chan}(curr_btChan)));
        set(h.edit_bt,'String',num2str(p_panel{1}(curr_chan,curr_btChan)));
    else
        set(h.edit_bt,'String','0','enable','off');
    end
    
    if nExc > 1
        % modified by MH, 29.3.2019
%         set(h.popupmenu_excDirExc,'Visible','on');
%         set([h.text_dirExc,h.edit_dirExc,h.popupmenu_excDirExc,...
%             h.edit_dirExc],'Enable','on');
%         set(h.text_dirExc,'String','DE calculation based on:');
%         set(h.edit_dirExc, 'String', ...
%             num2str(p_panel{2}{curr_exc,curr_chan}(curr_dirExc)));
        l0 = find(exc==chanExc(curr_chan));
        if isempty(l0) % no emitter-specific laser defined
            set(h.popupmenu_corr_exc, 'Value', 1,'String',{'none'});
            set(h.edit_dirExc,'String','0');
            set([h.popupmenu_corr_exc,h.edit_dirExc],'Enable','off');
        else
            l0 = l0(1);
            set(h.popupmenu_corr_exc, 'Value', 1, 'String', ...
                getStrPop('dir_exc',{exc l0}));
            set(h.popupmenu_corr_exc, 'Value', curr_exc);
            set([h.text_TP_cross_by,h.popupmenu_corr_exc],'Visible','on');
            set([h.popupmenu_corr_exc,h.text_TP_cross_de,h.edit_dirExc],...
                'Enable','on');
            set(h.edit_dirExc, 'String', ...
                num2str(p_panel{2}(curr_exc,curr_chan)));
        end
        
    else
        % modified by MH, 29.3.2019
        set(h.edit_dirExc,'Enable','off','String','0');
    end
    
    % modified by MH, 3.4.2019
%     if nFRET > 0 && curr_fret>=1
    if nFRET > 0
        if curr_fret>=1
            
            % modified by MH, 3.4.2019
%             set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
%                 h.text_TP_factors_method h.popupmenu_TP_factors_method ...
%                 h.text_TP_factors_gamma],'Enable','on');
            set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
                h.text_TP_factors_method h.popupmenu_TP_factors_method ...
                h.text_TP_factors_gamma h.pushbutton_optGamma],'Enable',...
                'on');

            set(h.popupmenu_gammaFRET,'Value',curr_fret+1);
            set(h.edit_gammaCorr,'String',num2str(p_panel{3}(curr_fret)));

            switch p_panel{4}(1)
                case 0 % manual
                    set(h.edit_gammaCorr,'Enable','on');
                    
                    % modified by MH, 3.4.2019
%                     set(h.pushbutton_optGamma,'enable','off');
                    set(h.pushbutton_optGamma,'String','Load');

                case 1 % photobleaching based
                    set(h.edit_gammaCorr,'Enable','inactive');
                    
                    % modified by MH, 3.4.2019
%                     set(h.pushbutton_optGamma,'enable','on');
                    set(h.pushbutton_optGamma,'String','Opt.');
                    
            end
            set(h.popupmenu_TP_factors_method,'Enable','on','Value',...
                p_panel{4}(1)+1);
        
        % added by MH, 3.4.2019
        else
            set([h.text_TP_factors_data,h.popupmenu_gammaFRET],'Enable',...
                'on')
            set([h.text_TP_factors_method h.popupmenu_TP_factors_method ...
                h.text_TP_factors_gamma, h.edit_gammaCorr ...
                h.pushbutton_optGamma],'Enable','off');
        end
        
    else
        set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
            h.text_TP_factors_method h.popupmenu_TP_factors_method ...
            h.text_TP_factors_gamma h.edit_gammaCorr ...
            h.pushbutton_optGamma],'Enable','off');
        set(h.edit_gammaCorr,'String','');
    end
end
