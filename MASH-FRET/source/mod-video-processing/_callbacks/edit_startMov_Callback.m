function edit_startMov_Callback(obj, evd, h_fig)

% collect VP parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
stop = curr.edit{2}(2);

% retrieve value from edit field
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val<=stop && val>=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Starting frame must be <= ending frame and >= 1.', h_fig, ...
        'error');
    return
end

% save upper bound of frame range in exported video
curr.edit{2}(1) = val;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_edExpVidPan(h_fig);
