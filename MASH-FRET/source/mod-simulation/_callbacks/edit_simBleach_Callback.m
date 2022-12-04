function edit_simBleach_Callback(obj, evd, h_fig)

% update by MH, 19.12.2019: delete previous state sequences (and associated results) when bleaching time constant changes

% collect parameters
h = guidata(h_fig);
p = h.param;
inSec = p.proj{p.curr_proj}.time_in_sec;
rate = p.proj{p.curr_proj}.sim.curr.gen_dt{1}(4);

% retrieve bleaching time constant from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Photobleaching time constant must be >= 0','error',h_fig);
    return
end

% convert to sampling steps units
if inSec
    val = val*rate;
end

p.proj{p.curr_proj}.sim.curr.gen_dt{1}(6) = val;

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_moleculesPan(h_fig);