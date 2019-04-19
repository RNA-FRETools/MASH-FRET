function edit_thm_xlim1_Callback(obj, evd, h)
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

    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    maxVal = prm.plot{1}(1,3);

    if isInt
        if perSec
            maxVal = maxVal/expT;
        end
        if perPix
            maxVal = maxVal/nPix;
        end
    end

    if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
        setContPan(sprintf(['Lower limit of x-axis must be lower than ' ...
            '%d.'],maxVal), 'error', h.figure_MASH);
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

        prm.plot{1}(1,2) = val;
        prm.plot{2} = [];
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end