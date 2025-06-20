function edit_thm_maxGaussNb_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
curr = p.proj{proj}.HA.curr{tag,tpe};

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(isscalar(val) && ~isnan(val) && val>0)
    setContPan(['The max. number of Gaussians should be a positive' ...
        ' integer'], 'error', h_fig);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

curr.thm_start{4}(1,3) = val;
p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');

