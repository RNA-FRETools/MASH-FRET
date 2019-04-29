function edit_TDP_nExp_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val > 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Number of exponential decays must be positive', ...
            'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
        kin_k = p.proj{proj}.prm{tpe}.kin_start;
        prev_val = kin_k{trs,1}(2);
        if prev_val ~= val
            for t = 1:val
                if prev_val < t
                    kin_k{trs,2}(t,:) = kin_k{trs,2}(t-1,:);
                end
            end
            kin_k{trs,2} = kin_k{trs,2}(1:val,:);
            kin_k{trs,1}(2) = val;
            if kin_k{trs,1}(3) > val
                kin_k{trs,1}(3) = val;
            end
            p.proj{proj}.prm{tpe}.kin_start = kin_k;
            p.proj{proj}.prm{tpe}.kin_res(trs,:) = cell(1,5);
            h.param.TDP = p;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'TDP');
        end
    end
end