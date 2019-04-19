function edit_TDPxBin_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val > 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Interval numbers must be > 0', 'error', ...
            h.figure_MASH);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        p.proj{proj}.prm{tpe}.plot{1}(1,1) = val;
        p.proj{proj}.prm{tpe}.plot{2} = [];
        p.proj{proj}.prm{tpe}.plot{3} = [];
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
    end
end