function edit_bgInt_don_Callback(obj, evd, h_fig)

% retrieve donor background intensity from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Intensities must be >= 0', 'error', h_fig);
    return
end

% retrieve simulation parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.sim.curr;
inun = curr.gen_dat{3}{2};
noisetype = curr.gen_dat{1}{2}{4};
noiseprm = curr.gen_dat{1}{2}{5};

% convert intensity to PC
if strcmp(inun, 'electron')
    [offset,K,eta] = getCamParam(noisetype,noiseprm);
    val = ele2phtn(val,K,eta);
end

% save modifications
curr.gen_dat{8}{2}(1) = val;

p.proj{p.curr_proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_expSetupPan(h_fig);
