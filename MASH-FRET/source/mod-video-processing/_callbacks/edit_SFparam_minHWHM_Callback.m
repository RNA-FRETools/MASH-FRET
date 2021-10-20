function edit_SFparam_minHWHM_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. spot width must be a number.', h_fig, 'error');
    return
end

% collect processing parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
coordslct = curr.gen_crd{2}{5};

% save minimum spot width
curr.gen_crd{2}{3}(3) = val;

% reset spot selection
if size(coordslct,1)>=0
    curr.gen_crd{2}{5} = [];
end

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');
