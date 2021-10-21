function edit_SFparam_w_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = str2double(get(obj,'string'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>0 && mod(val,2))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Spot width must be an odd number > 0.', h_fig, 'error');
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;
chan = get(h.popupmenu_SFchannel,'value');

p.proj{p.curr_proj}.VP.curr.gen_crd{2}{2}(chan,5) = val;

h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
