function edit_thm_ampUp_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};

    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,2);
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal)
        setContPan(sprintf(['The upper limit of Gaussian amplitude ' ...
            'must be higher than the starting value (%d)'],minVal), ...
            'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{3}(gauss,3) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end