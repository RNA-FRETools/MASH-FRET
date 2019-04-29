function edit_thm_fwhmLow_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};

    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);

    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    maxVal = prm.thm_start{3}(gauss,8);

    if isInt
        if perSec
            maxVal = maxVal/expT;
        end
        if perPix
            maxVal = maxVal/nPix;
        end
    end

    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
        setContPan(sprintf(['The lower limit of Gaussian FWHM ' ...
            'must be lower than the starting value (%d)'],maxVal), ...
            'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);

        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end

        prm.thm_start{3}(gauss,7) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end