function edit_TDPbin_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Interval numbers must be > 0', 'error', ...
        h_fig);
    return
end

set(obj, 'BackgroundColor', [1 1 1]);
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

p.proj{proj}.curr{tag,tpe}.plot{1}(1,1) = val;

h.param.TDP = p;
guidata(h_fig, h);

ud_TDPplot(h_fig);