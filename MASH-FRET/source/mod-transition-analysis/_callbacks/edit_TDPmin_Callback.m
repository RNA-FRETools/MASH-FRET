function edit_TDPmin_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

val = str2num(get(obj, 'String'));
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

maxVal = p.proj{proj}.TA.curr{tag,tpe}.plot{1}(1,3);

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val < maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Axis lower limit must be < ' num2str(maxVal)], 'error', ...
        h_fig);
    return
end

p.proj{proj}.TA.curr{tag,tpe}.plot{1}(1,2) = val;

h.param = p;
guidata(h_fig, h);

ud_TDPplot(h_fig);

