function edit_yDark_Callback(obj, evd, h)
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
        val = str2num(get(obj, 'String'));
        res_y = p.proj{proj}.movie_dim(2);
        itgDim = p.proj{proj}.pix_intgr(1);

        valMin = itgDim/2;
        valMax = res_y - itgDim/2;

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val > valMin && val < valMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Dark y-coordinates must be > ' ...
                num2str(valMin) ' and < ' num2str(valMax)], ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{3}{3}{l,c}(method,5) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_ttBg(h.figure_MASH);
            updateFields(h.figure_MASH, 'subImg');
        end
    end
end