function edit_TA_mdlRestartNb_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('The number of process restarts is ill-defined.', 'error', ...
        h_fig);
    return
end

p.proj{proj}.TA.curr{tag,tpe}.mdl_start(2) = val;

h.param = p;
guidata(h_fig, h);

ud_kinMdl(h_fig);