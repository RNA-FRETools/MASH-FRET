function edit_stateVal_Callback(obj, evd, h_fig)

% retrieve FRET value from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>=0 && val<=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('FRET values must be >= 0 and <= 1', 'error', h_fig);
    return
end

% save modifications to project
h = guidata(h_fig);
p = h.param;
state = get(h.popupmenu_states, 'Value');

p.proj{p.curr_proj}.sim.curr.gen_dat{2}(1,state) = val;

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_moleculesPan(h_fig);
