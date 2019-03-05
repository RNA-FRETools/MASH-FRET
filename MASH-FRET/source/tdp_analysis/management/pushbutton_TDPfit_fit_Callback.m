function pushbutton_TDPfit_fit_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    prm = p.proj{proj}.prm{tpe};
    curr_k = prm.clst_start{1}(4);
    J = prm.clst_res{3};
    dat = prm.clst_res{1}.clusters{J};
    ref_k = prm.clst_res{4}{curr_k};
    kin_k = prm.kin_start(curr_k,:);
    stchExp = kin_k{1}(1);
    
    k = 0;
    for j1 = 1:J
        for j2 = 1:J
            if j1 ~= j2
                k = k+1;
                if k == curr_k
                    break;
                end
            end
        end
        if k == curr_k
            break;
        end
    end
    
    if stchExp
        % amp, dec, beta
        p_fit.lower = kin_k{2}(1,[1 4 7]);
        p_fit.start = kin_k{2}(1,[2 5 8]);
        p_fit.upper = kin_k{2}(1,[3 6 9]);
    else
        % amp1, dec1, amp2, dec2 ...
        p_fit.lower = reshape(kin_k{2}(:,[1 4])', [1 ...
            numel(kin_k{2}(:,[1 4]))]);
        p_fit.start = reshape(kin_k{2}(:,[2 5])', [1 ...
            numel(kin_k{2}(:,[2 5]))]);
        p_fit.upper = reshape(kin_k{2}(:,[3 6])', [1 ...
            numel(kin_k{2}(:,[3 6]))]);
    end
    
    boba = kin_k{1}(4);
    p_boba = [];
    if boba
        p_boba = kin_k{1}([5 6 7]);
    end
    
    excl = questdlg({['The first and the last durations often lead to ' ...
        'biased state dswells.'], ['For more reliable results, it is ' ...
        'recommended to exclude them.'], ['Exclude the trucated ' ...
        'durations?']}, 'Exclude flanking dwell-times?', 'Exclude', ...
        'Include', 'Cancel', 'Exclude');

    if strcmp(excl, 'Exclude')
        excl = 1;
    elseif strcmp(excl, 'Include')
        excl = 0;
    else
        return;
    end
    
    kin_k{1}(8) = excl;
    
    prm.kin_res(curr_k,:) = cell(1,5);
    
    setContPan('Fitting in progress ...', 'process', h.figure_MASH);
    
    res = fitDt(dat, j1, j2, excl, ref_k, p_fit, p_boba, h.figure_MASH);
    if isempty(res)
        return;
    end

    prm.kin_start(curr_k,:) = kin_k;
    
    if boba
        % update number of replicates
        prm.kin_start{curr_k,1}(5) = res.n_rep;
        prm.kin_res{curr_k,1} = res.boba_mean;
        prm.kin_res{curr_k,3} = res.boba_inf;
        prm.kin_res{curr_k,4} = res.boba_sup;
    end

    prm.kin_res{curr_k,2} = res.fit_ref;

    p.proj{proj}.prm{tpe} = prm;
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
    
    if boba
        if stchExp
            str = ['The graph illustrates both the variation in the',...
                'decay constant and the stretching factor beta.'];
        else
            str = ['The graph illustrates the variation in the',...
                'decay constant.'];
        end

        if p_boba(3) % weighting
            str1 = str;
            str2 = ['(1) You have performed weighted bootstrapping, ' ...
                'i.e. time traces with longer observation times are ' ...
                'more likely to be selected. This will naturally favor' ...
                'the selection of longer dwell times and may lead to ' ...
                'deviations from the reference (blue dots, solid line)' ...
                '.\n\n(2) '];
            str = sprintf([str2,str1]);
        end
        
        setContPan(str, 'success', h.figure_MASH);
    else
        setContPan('Fitting completed.', 'success', h.figure_MASH);
    end
end