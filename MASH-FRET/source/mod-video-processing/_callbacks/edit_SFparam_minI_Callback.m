function edit_SFparam_minI_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be >= 0.'], h_fig, ...
        'error');
end

% collect VP parameters
h = guidata(h_fig);
p = h.param;
expT = p.proj{p.curr_proj}.sampling_time;
persec = p.proj{p.curr_proj}.cnt_p_sec;
curr = p.proj{p.curr_proj}.VP.curr;
refineprm = curr.gen_crd{2}{3};

% convert intensity units
if persec
    val = val*expT;
end

% save minimum spot intensity
chan = get(h.popupmenu_SFchannel,'value');
refineprm(chan,2) = val;

% refine spots coordinates and update interface
refinespots(refineprm,h_fig);
