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
v = p.proj{proj}.curr{tag,tpe}.lft_start{2}(2);
lft_k = p.proj{proj}.curr{tag,tpe}.lft_start{1};
prev_val = lft_k{v,1}(3);
if prev_val==val
    return
end

for t = 1:val
    if prev_val < t
        lft_k{v,2}(t,:) = lft_k{v,2}(t-1,:);
    end
end
lft_k{v,2} = lft_k{v,2}(1:val,:);
lft_k{v,1}(3) = val;
if lft_k{v,1}(4) > val
    lft_k{v,1}(4) = val;
end

p.proj{proj}.curr{tag,tpe}.lft_start{1} = lft_k;

h.param.TDP = p;
guidata(h_fig, h);

ud_fitSettings(h_fig);

