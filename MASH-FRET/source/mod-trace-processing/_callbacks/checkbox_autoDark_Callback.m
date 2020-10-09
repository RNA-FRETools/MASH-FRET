function checkbox_autoDark_Callback(obj, evd, h_fig)
h = guidata(h_fig);
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
    
    method = p.proj{proj}.curr{mol}{3}{2}(l,c);
    if method == 6 % dark trace
        val = get(obj, 'Value');
        p.proj{proj}.curr{mol}{3}{3}{l,c}(method,6) = val;
        h.param.ttPr = p;
        guidata(h_fig, h);
        ud_ttBg(h_fig);
        updateFields(h_fig, 'subImg');
    end
end