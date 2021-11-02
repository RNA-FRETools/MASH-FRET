function edit_dstrbNoise_Callback(obj, evd, h_fig)

% retrieve intensity broadening width from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Intensities must be >= 0', 'error', h_fig);
    return
end

% collect simulation parameters
h = guidata(h_fig);
p = h.param;
perSec = p.proj{p.curr_proj}.cnt_p_sec;
curr = p.proj{p.curr_proj}.sim.curr;
rate = curr.gen_dt{1}(4);
inun = curr.gen_dat{3}{2};
noisetype = curr.gen_dat{1}{2}{4};
noiseprm = curr.gen_dat{1}{2}{5};

% convert intensity units
if strcmp(inun, 'electron')
    [~,K,eta] = getCamParam(noisetype,noiseprm);
    val = ele2phtn(val,K,eta);
end
if perSec
    val = val/rate;
end

% save modifications
curr.gen_dat{3}{1}(2) = val;

p.proj{p.curr_proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_moleculesPan(h_fig);
