function edit_SFparam_minDspot_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. peak-peak distance must be >= 0.', h_fig, 'error');
end

% collect processing parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
refineprm = curr.gen_crd{2}{3};

% save minimum inter-spot distance
chan = get(h.popupmenu_SFchannel,'value');
refineprm(chan,6) = val;

% refine spots coordinates and update interface
refinespots(refineprm,h_fig);
