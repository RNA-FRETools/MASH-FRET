function edit_psfW1_Callback(obj, evd, h_fig)

% retrieve donor PSF width value from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('PSF full width at half maximum must be > 0','error',h_fig);
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.sim.curr;
def = p.proj{p.curr_proj}.sim.def;

curr.gen_dat{6}{3} = def.gen_dat{6}{3}; % reset factor matrices
curr.gen_dat{6}{2}(1) = val;

p.proj{p.curr_proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_expSetupPan(h_fig);