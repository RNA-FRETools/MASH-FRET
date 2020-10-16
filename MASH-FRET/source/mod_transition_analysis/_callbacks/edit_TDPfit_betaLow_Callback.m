function edit_TDPfit_betaLow_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Beta exponent must be >= 0', 'error', h_fig);
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
curr = p.proj{proj}.curr{tag,tpe};
v = curr.lft_start{2}(2);

p.proj{proj}.curr{tag,tpe}.lft_start{1}{v,2}(1,7) = val;

h.param.TDP = p;
guidata(h_fig, h);

ud_fitSettings(h_fig);
