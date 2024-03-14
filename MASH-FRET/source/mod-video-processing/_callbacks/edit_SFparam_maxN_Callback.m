function edit_SFparam_maxN_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. number of peak must be >= 0.', h_fig, 'error');
    return
end

% collect processing parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
refineprm = curr.gen_crd{2}{3};

% save maximum number of spots
chan = get(h.popupmenu_SFchannel,'value');
refineprm(chan,1) = val;

% refine spots coordinates and update interface
refinespots(refineprm,h_fig);
