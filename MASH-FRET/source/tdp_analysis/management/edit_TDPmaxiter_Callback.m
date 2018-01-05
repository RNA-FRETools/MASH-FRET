function edit_TDPmaxiter_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>=0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Maximum number of initilizations must be >= 0.', 'error', h.figure_MASH);
    else
        p.proj{proj}.prm{tpe}.clst_start{1}(5) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end