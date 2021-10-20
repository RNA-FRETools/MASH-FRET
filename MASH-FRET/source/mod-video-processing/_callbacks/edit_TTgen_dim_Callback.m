function edit_TTgen_dim_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = str2double(get(obj,'string'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Integration area dimensions must be an integer > 0.', ...
        h_fig, 'error');
end

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.VP.curr.gen_int{3}(1) = val;
p.proj{p.curr_proj}.VP.curr.gen_int{3}(2) = val^2;

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_intIntegrPan(h_fig);
