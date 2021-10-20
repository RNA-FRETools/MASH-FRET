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
expT = p.proj{p.curr_proj}.frame_rate;
curr = p.proj{p.curr_proj}.VP.curr;
coordslct = curr.gen_crd{2}{5};
persec = curr.plot{1}(1);

% convert intensity units
if persec
    val = val/expT;
end

% save minimum spot intensity
curr.gen_crd{2}{3}(2)= val;
    
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
