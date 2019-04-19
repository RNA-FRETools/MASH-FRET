function edit_TDPfit_betaLow_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Beta exponent must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(1,7) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end