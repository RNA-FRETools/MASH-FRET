function edit_SFparam_h_Callback(obj, evd, h_fig)

val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val) == 1 && ~isnan(val) && val > 0 && mod(val,2))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Spot height must be an odd number > 0.', h_fig, 'error');
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;
chan = get(h.popupmenu_SFchannel, 'Value');

p.proj{p.curr_proj}.VP.curr.gen_crd{2}{2}(chan,6) = val;

h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
