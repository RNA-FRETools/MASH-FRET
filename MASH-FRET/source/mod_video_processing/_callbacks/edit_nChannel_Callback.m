function edit_nChannel_Callback(obj, evd, h)
nChan = round(str2num(get(obj, 'String')));
if ~(~isempty(nChan) && numel(nChan) == 1 && ~isnan(nChan) && ...
        nChan > 0)
    updateActPan('Number of channel must be > 0.', ...
        h.figure_MASH, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    p = h.param.movPr;
    p.nChan = nChan;

    if isfield(h, 'movie')
        sub_w = round(h.movie.pixelX/nChan);
        h.movie.split = (1:nChan-1)*sub_w;
        txt_split = [];
        for i = 1:size(h.movie.split,2)
            txt_split = [txt_split ' ' num2str(h.movie.split(i))];
        end
        set(h.text_split, 'String', ['Channel splitting: ' txt_split]);
    end

    clr_ref = getDefTrClr(p.itg_nLasers, p.itg_wl, nChan, size(p.itg_expFRET,1), ...
        size(p.itg_expS,1));

    for c = 1:nChan
        if c > size(p.itg_clr{1},2)
            p.itg_clr{1}(:,(size(p.itg_clr{1},2)+1):size(clr_ref{1},2)) ...
                = clr_ref{1}(:,(size(p.itg_clr{1},2)+1):end);
        end
        if c > size(p.labels_def,2)
            p.labels_def{c} = sprintf('Cy%i', (2*c+1));
        end
        if c > size(p.chanExc,2)
            if c <= p.itg_nLasers
                p.chanExc(c) = p.itg_wl(c);
            else
                p.chanExc(c) = 0;
            end
        end
    end
    p.labels = p.labels_def(1:nChan);
    p.chanExc = p.chanExc(1:nChan);
    p.itg_expFRET(~~sum(p.itg_expFRET>nChan),:) = [];
    set(h.popupmenu_bgChanel, 'Value', 1);
    set(h.popupmenu_SFchannel, 'Value', 1);

    % Set fields to proper values
    p.SFres = {};
    h.param.movPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'imgAxes');
end