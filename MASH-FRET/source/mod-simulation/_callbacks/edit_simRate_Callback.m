function edit_simRate_Callback(obj, evd, h_fig)

% update by MH, 19.12.2019: delete previous state sequences (and associated results) when rate changes

% retrieve frame rate value  from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Frame rate must be > 0', 'error', h_fig);
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dt{1}(4) = val;

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_vidParamPan(h_fig);
