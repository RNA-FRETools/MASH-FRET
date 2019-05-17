function edit_trBgCorr_bgInt_Callback(obj, evd, h)
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
    if method == 1
        val = str2num(get(obj, 'String'));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Background intensity must be a number.', ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            perSec = p.proj{proj}.fix{2}(4);
            perPix = p.proj{proj}.fix{2}(5);
            if perSec
                rate = p.proj{proj}.frame_rate;
                val = val*rate;
            end
            if perPix
                nPix = p.proj{proj}.pix_intgr(2);
                val = val*nPix;
            end
            p.proj{proj}.curr{mol}{3}{3}{l,c}(method,3) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_ttBg(h.figure_MASH);
        end
    end
end