function edit_TDPiniVal_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('State values must be numeric.', 'error', ...
        h_fig);
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
state = get(h.popupmenu_TDPstate, 'Value');

p.proj{proj}.curr{tag,tpe}.clst_start{2}(state,1) = val;

h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');

