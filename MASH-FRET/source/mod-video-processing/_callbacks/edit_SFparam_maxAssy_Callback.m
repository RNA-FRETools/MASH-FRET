function edit_SFparam_maxAssy_Callback(obj, evd, h_fig)

% retrieve max. spot assymetry from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val) == 1 && ~isnan(val) && val >= 100)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. spot assymetry must be a number >= 100.', h_fig, ...
        'error');
    return
end

% collect VP parameters
h = guidata(h_fig);
p = h.param.movPr;
curr = p.proj{p.curr_proj}.VP.curr;
coordslct = curr.gen_crd{2}{5};

% save assymetry value
chan = get(h.popupmenu_SFchannel, 'Value');
curr.gen_crd{2}{3}(chan,5) = val;

% reset spot selection
if size(coordslct,1)>=0
    curr.gen_crd{2}{5} = [];
end

% save modifications
h.param = p;
guidata(h_fig, h);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');
