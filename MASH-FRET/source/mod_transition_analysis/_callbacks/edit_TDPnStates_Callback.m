function edit_TDPnStates_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val > 1)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Max. number of states must be > 1', 'error', ...
            h_fig);
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        tag = p.curr_tag(proj);
        prm = p.proj{proj}.prm{tag,tpe};
        trs_k = prm.clst_start;
        val_prev = trs_k{1}(3);
        
        % update colour list
        str_clr = get(h.popupmenu_TDPcolour, 'String');
        nClr = size(str_clr,1);
        if nClr < val*(val-1)
            p.colList(nClr+1:val*(val-1),:) = ...
                round(rand(val*(val-1)-nClr,3)*100)/100;
        end
        
        % update parameters
        for s = 1:val
            if val_prev < s
                trs_k{2}(s,:) = trs_k{2}(s-1,:);
            end
        end
        trs_k{2} = trs_k{2}(1:val,:);
        
        for v = 1:val*(val-1)
            if val_prev*(val_prev-1) < v 
                trs_k{3}(v,:) = p.colList(v,:);
            end
            if v > nClr
                str_clr = [str_clr;sprintf('random %i',v)];
            end
        end
        trs_k{3} = trs_k{3}(1:val*(val-1),:);
        set(h.popupmenu_TDPcolour, 'String', str_clr);
        
        trs_k{1}(3) = val;
        if trs_k{1}(4) > val*(val-1)
            trs_k{1}(4) = val*(val-1);
        end

        prm.clst_start = trs_k;
        prm.clst_res = cell(1,4);
        prm.kin_res = cell(1,5);
        p.proj{proj}.prm{tag,tpe} = prm;
        h.param.TDP = p;
        guidata(h_fig, h);
        updateFields(h_fig, 'TDP');
    end
end