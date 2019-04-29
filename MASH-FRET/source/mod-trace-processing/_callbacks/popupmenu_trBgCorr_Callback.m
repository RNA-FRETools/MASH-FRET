function popupmenu_trBgCorr_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    nExc = p.proj{proj}.nb_excitations;
    nChan = p.proj{proj}.nb_channel;
    
    % get channel and laser corresponding to selected data
    selected_chan = p.proj{proj}.fix{3}(6);
    chan = 0;
    for l = 1:nExc
        for c = 1:nChan
            chan = chan+1;
            if chan==selected_chan
                break;
            end
        end
        if chan==selected_chan
            break;
        end
    end
    
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{3}{2}(l,c) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_ttBg(h.figure_MASH);
end