function edit_TDPnSpl_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('The number of samples must be > 0', 'error', ...
        h_fig);
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

p.proj{proj}.curr{tag,tpe}.clst_start{1}(7) = val;

h.param.TDP = p;
guidata(h_fig, h);

ud_TDPmdlSlct(h_fig);

