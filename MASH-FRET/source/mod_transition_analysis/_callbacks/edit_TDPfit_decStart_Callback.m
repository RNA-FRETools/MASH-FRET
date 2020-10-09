function edit_TDPfit_decStart_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Exp. time decay must be >= 0', 'error', h_fig);
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
curr = p.proj{proj}.curr{tag,tpe};
trs = curr.kin_start{2}(2);
strch = curr.kin_start{1}{trs,1}(1);
if strch
    n = 1;
else
    n = p.proj{proj}.curr{tag,tpe}.kin_start{1}{trs,1}(3);
end

p.proj{proj}.curr{tag,tpe}.kin_start{1}{trs,2}(n,5) = val;

h.param.TDP = p;
guidata(h_fig, h);

ud_kinFit(h_fig);
