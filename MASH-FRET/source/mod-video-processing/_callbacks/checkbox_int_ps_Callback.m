function checkbox_int_ps_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'VP')
    return
end

p.proj{p.curr_proj}.VP.curr.plot{1}(1) = get(obj, 'Value');

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig, 'imgAxes');