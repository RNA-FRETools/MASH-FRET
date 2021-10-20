function edit_SFparam_darkH_Callback(obj, evd, h_fig)

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
meth = curr.gen_crd{2}{1}(1);

% get intensity threshold from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if meth~=4 && ~(numel(val)==1 && ~isnan(val) && mod(val,2) && val>0) % not Schmied
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Dark area height must be an odd integer > 0.', h_fig, ...
        'error');
    return
elseif meth==4 && ~(numel(val)==1 && ~isnan(val) && val>=0) % Schmied
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Distance from edge must be a positive integer.', h_fig, ...
        'error');
    return
end

% collect VP parameters
p = h.param;
chan = get(h.popupmenu_SFchannel, 'Value');

% save modifications

p.proj{p.curr_proj}.VP.curr.gen_crd{2}{2}(chan,4);

h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
