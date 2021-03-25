function edit_thm_centreUp_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    tag = p.curr_tag(proj);
    prm = p.proj{proj}.prm{tag,tpe};

    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);

    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,5);

    if isInt
        if perSec
            minVal = minVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
        end
    end

    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal)
        setContPan(sprintf(['The upper limit of Gaussian center must ' ...
            'be higher than the starting value (%d)'],minVal), 'error', ...
            h_fig);
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
        prm.thm_start{3}(gauss,6) = val;
        p.proj{proj}.prm{tag,tpe} = prm;
        h.param.thm = p;
        guidata(h_fig, h);
        updateFields(h_fig, 'thm');
    end
end