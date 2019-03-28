function ud_cross(h_fig)

% Last update: 28.3.2019 by MH
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
    curr_dirExc = p{proj}.fix{3}(7);
    exc = p{proj}.excitations;
    nChan = p{proj}.nb_channel;
    FRET = p{proj}.FRET;
    nFRET = size(FRET,1);
    nExc = numel(exc);
    labels = p{proj}.labels;
    clr = p{proj}.colours;
    
    set(h.popupmenu_corr_exc, 'Value', curr_exc);

    set(h.popupmenu_corr_chan, 'Value', curr_chan, 'String', ...
        getStrPop('chan', {labels curr_exc clr{1}}));
    
    set(h.popupmenu_bt, 'Value', 1, 'String', getStrPop('bt_chan', ...
        {labels curr_chan curr_exc clr{1}}));
    set(h.popupmenu_bt, 'Value', curr_btChan);
    
    set(h.popupmenu_excDirExc, 'Value', 1, 'String', ...
        getStrPop('dir_exc',{exc curr_exc curr_chan clr{1}}));
    
    set(h.popupmenu_gammaFRET, 'Value', 1, 'String', ...
        getStrPop('corr_gamma', {FRET labels clr}));
    
    set(h.popupmenu_excDirExc, 'Value', curr_dirExc);
    if nChan > 1
        set(h.edit_bt, 'String', ...
            num2str(p_panel{1}{curr_exc,curr_chan}(curr_btChan)));
    end
    if nExc > 1
        set(h.popupmenu_excDirExc,'Visible','on');
        set([h.text_dirExc,h.edit_dirExc,h.popupmenu_excDirExc,...
            h.edit_dirExc],'Enable','on');
        set(h.text_dirExc,'String','DE calculation based on:');
        set(h.edit_dirExc, 'String', ...
            num2str(p_panel{2}{curr_exc,curr_chan}(curr_dirExc)));
    else
        set(h.popupmenu_excDirExc,'Visible','off');
         set([h.text_dirExc,h.edit_dirExc,h.popupmenu_excDirExc,...
             h.edit_dirExc],'Enable','off');
        set(h.text_dirExc,'String','DE coefficient:');
        set(h.edit_dirExc,'String',num2str(0));
    end
    
    if nFRET > 0 && curr_fret>=1
        set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
            h.text_TP_factors_method h.popupmenu_TP_factors_method ...
            h.text_TP_factors_gamma],'Enable','on');
        
        set(h.popupmenu_gammaFRET,'Value',curr_fret+1);
        set(h.edit_gammaCorr,'String',num2str(p_panel{3}(curr_fret)));

        switch p_panel{4}(1)
            case 0 % manual
                set(h.edit_gammaCorr,'Enable','on');
                set(h.pushbutton_optGamma,'enable','off');
                
            case 1 % photobleaching based
                set(h.edit_gammaCorr,'Enable','inactive');
                set(h.pushbutton_optGamma,'enable','on');
        end
        set(h.popupmenu_TP_factors_method,'Enable','on','Value',...
            p_panel{4}(1)+1);
        
    else
        set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
            h.text_TP_factors_method h.popupmenu_TP_factors_method ...
            h.text_TP_factors_gamma h.edit_gammaCorr ...
            h.pushbutton_optGamma],'Enable','off');
        set(h.edit_gammaCorr,'String','');
    end
end
