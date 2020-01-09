function edit_xDark_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    
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
        res_x = p.proj{proj}.movie_dim(1);
        lim = [0 round(res_x/nChan)*(1:(nChan-1)) res_x];
        itgDim = p.proj{proj}.pix_intgr(1);

        valMin = lim(chan) + itgDim/2;
        valMax = lim(chan+1) - itgDim/2;

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val > valMin && val < valMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Dark x-coordinates must be > ' ...
                num2str(valMin) ' and < ' num2str(valMax)], ...
                h_fig, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{3}{3}{l,c}(method,4) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            ud_ttBg(h_fig);
            updateFields(h_fig, 'subImg');
        end
    end
end