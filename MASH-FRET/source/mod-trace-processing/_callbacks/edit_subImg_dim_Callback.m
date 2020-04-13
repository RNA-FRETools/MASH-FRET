function edit_subImg_dim_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    if p.proj{proj}.is_coord && p.proj{proj}.is_movie
        val = str2num(get(obj, 'String'));
        res_x = p.proj{proj}.movie_dim(1);
        nC = p.proj{proj}.nb_channel;
        subW = round(res_x/nC);
        minVal = min([subW (res_x-(nC-1)*subW)]);
        set(obj, 'String', num2str(val));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 ...
                && val <= minVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Subimage dimensions must be > 0 and <= ' ...
                num2str(minVal)], h_fig , 'error');
            
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            
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
            p.proj{proj}.curr{mol}{3}{3}{l,c}(method,2) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            updateFields(h_fig, 'subImg');
        end
    end
end