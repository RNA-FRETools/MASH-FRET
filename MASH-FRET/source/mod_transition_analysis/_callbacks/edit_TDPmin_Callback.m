function edit_TDPmin_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = str2num(get(obj, 'String'));
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
maxVal = p.proj{proj}.curr{tag,tpe}.plot{1}(1,3);

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val < maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Axis lower limit must be < ' num2str(maxVal)], ...
        'error', h_fig);
    return
end

p.proj{proj}.curr{tag,tpe}.plot{1}(1,2) = val;

h.param.TDP = p;
guidata(h_fig, h);

ud_TDPplot(h_fig);

