function edit_thm_threshVal_Callback(obj, evd, h_fig)
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

    thresh = get(h.popupmenu_thm_thresh, 'Value');
    N = size(prm.thm_start{2},1);
    val = str2num(get(obj, 'String'));
    if thresh==1 && N>1
        minVal = -Inf;
        maxVal = prm.thm_start{2}(thresh+1);
    elseif thresh==N && N>1
        minVal = prm.thm_start{2}(thresh-1);
        maxVal = Inf;
    elseif N==1
        minVal = -Inf;
        maxVal = Inf;
    else
        minVal = prm.thm_start{2}(thresh-1);
        maxVal =  prm.thm_start{2}(thresh+1);
    end

    if isInt
        if perSec
            minVal = minVal/expT;
            maxVal = maxVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
            maxVal = maxVal/nPix;
        end
    end

    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val)&& val>minVal && val<maxVal)
        setContPan(sprintf(['Threshold value must be higher than the ' ...
            'previous threshold (%d) and lower than the next threshold' ...
            '(%d)'], minVal, maxVal), ...
            'error', h_fig);
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

        prm.thm_start{2}(thresh) = val;
        p.proj{proj}.prm{tag,tpe} = prm;
        h.param.thm = p;
        guidata(h_fig, h);
        updateFields(h_fig, 'thm');
    end
end