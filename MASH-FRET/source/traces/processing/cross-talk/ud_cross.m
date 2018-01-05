function ud_cross(h_fig)
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
        set(h.edit_dirExc, 'String', ...
            num2str(p_panel{2}{curr_exc,curr_chan}(curr_dirExc)));
    end
    if nFRET > 0
        set(h.popupmenu_gammaFRET, 'Enable', 'on', 'Value', curr_fret+1);
        if curr_fret>=1
            set(h.edit_gammaCorr, 'Enable', 'on', 'String', ...
                num2str(p_panel{3}(curr_fret)));
        end
    else
        set(h.edit_gammaCorr, 'String', '');
        set([h.popupmenu_gammaFRET h.edit_gammaCorr], 'Enable', 'off');
    end
end