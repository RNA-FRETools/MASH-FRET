function edit_thm_xlim2_Callback(obj, evd, h)
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
    minVal = prm.plot{1}(1,2);

    if isInt
        if perSec
            minVal = minVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
        end
    end

    if ~(numel(val)==1 && ~isnan(val) && val>minVal)
        setContPan(sprintf(['Upper limit of x-axis must be higher than' ...
            ' %d.'],minVal), 'error', h.figure_MASH);
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

        prm.plot{1}(1,3) = val;
        prm.plot{2} = [];
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end