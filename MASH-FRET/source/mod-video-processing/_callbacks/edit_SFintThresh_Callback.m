function edit_SFintThresh_Callback(obj, evd, h_fig)

% retrieve interface parameters
h = guidata(h_fig);

% get intensity threshold from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be >= 0.'],h_fig,...
        'error');
    return
end

% collect VP parameters
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
expT = p.proj{p.curr_proj}.frame_rate;
meth = curr.gen_crd{2}{1}(1);
coordslct = curr.gen_crd{2}{5};
persec = curr.plot{1}(1);

% save to project
chan = get(h.popupmenu_SFchannel, 'Value');
if meth==4 % Schmied2012
    curr.gen_crd{2}{2}(chan,2) = val;
else
    % convert to proper intensity units
    if persec
        val = val*expT;
    end
    curr.gen_crd{2}{2}(chan,1) = val;
end

% reset spot selection
if size(coordslct,1)>=1
    curr.gen_crd{2}{5} = [];
end

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
updateFields(h_fig,'movPr');
