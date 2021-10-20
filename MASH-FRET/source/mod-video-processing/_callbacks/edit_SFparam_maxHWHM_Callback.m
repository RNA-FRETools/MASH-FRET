function edit_SFparam_maxHWHM_Callback(obj, evd, h_fig)

% retrieve max. spot width from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. spot width must be a number.', h_fig, 'error');
    return
end

% collect VP parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
slctcrd = curr.gen_crd{2}{5};

% save to project
chan = get(h.popupmenu_SFchannel, 'Value');
curr.gen_crd{2}{3}(chan,4) = val;

% reset spot selection
if size(slctcrd,1)>=0
    curr.gen_crd{2}{5} = [];
end

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');
