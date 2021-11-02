function edit_length_Callback(obj, evd, h_fig)

% save modifications
h = guidata(h_fig);
p = h.param;
inSec = p.proj{p.curr_proj}.time_in_sec;
rate = p.proj{p.curr_proj}.sim.curr.gen_dt{1}(4);

% retrieve video length from edit field
val = str2num(get(obj, 'String'));
if inSec
    val = round(val*rate)/rate;
    minval = 1/rate;
else
    val = round(val);
    minval = 1;
end
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=minval)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Trace length must be >= ',num2str(minval)], 'error', h_fig);
    return
end

% convert to sampling steps units
if inSec
    val = val*rate;
end

p.proj{p.curr_proj}.sim.curr.gen_dt{1}(2) = val;

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_vidParamPan(h_fig);
