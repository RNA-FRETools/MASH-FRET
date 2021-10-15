function edit_bgExp_cst_Callback(obj, evd, h_fig)

% retrieve dynamic background time constant from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Time constant decay must be a number > 0', 'error', h_fig);
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{8}{5}(2) = val;

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_expSetupPan(h_fig);
