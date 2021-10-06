function edit_TDP_nExp_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Number of exponential decays must be positive', ...
        'error', h_fig);
    return
end

v = curr.lft_start{2}(2);
lft_k = curr.lft_start{1};
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

p.proj{proj}.TA.curr{tag,tpe}.lft_start{1} = lft_k;

h.param = p;
guidata(h_fig, h);

ud_fitSettings(h_fig);

