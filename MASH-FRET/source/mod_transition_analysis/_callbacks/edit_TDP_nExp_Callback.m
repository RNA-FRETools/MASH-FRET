function edit_TDP_nExp_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Number of exponential decays must be positive', ...
        'error', h_fig);
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
trs = p.proj{proj}.curr{tag,tpe}.kin_start{2}(2);
kin_k = p.proj{proj}.curr{tag,tpe}.kin_start{1};
prev_val = kin_k{trs,1}(2);
if prev_val==val
    return
end

for t = 1:val
    if prev_val < t
        kin_k{trs,2}(t,:) = kin_k{trs,2}(t-1,:);
    end
end
kin_k{trs,2} = kin_k{trs,2}(1:val,:);
kin_k{trs,1}(2) = val;
if kin_k{trs,1}(3) > val
    kin_k{trs,1}(3) = val;
end

p.proj{proj}.curr{tag,tpe}.kin_start{1} = kin_k;

h.param.TDP = p;
guidata(h_fig, h);

ud_kinFit(h_fig);

