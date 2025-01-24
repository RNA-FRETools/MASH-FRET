function edit_totInt_Callback(obj, evd, h_fig)

% retrieve intensity value from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && isscalar(val) && ~isnan(val) && val >= 0)
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
noisetype = curr.gen_dat{1}{2}{4};
noiseprm = curr.gen_dat{1}{2}{5};
inun = curr.gen_dat{3}{2};

% convert intensity units
if strcmp(inun, 'electron')
    [offset,K,eta] = getCamParam(noisetype,noiseprm);
    pc = ele2phtn(val,K,eta);
    setContPan(['given the camera settings, ',num2str(val),' electron counts ',...
        'approaches ',num2str(pc),' photon counts, which is exactly ',...
        'converted to ',num2str(phtn2ele(pc,K,eta)),'.'],'success',h_fig);
    val = pc;
end
if perSec
    val = val/rate;
end

% save modifications to project
curr.gen_dat{3}{1}(1) = val;
p.proj{p.curr_proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_moleculesPan(h_fig);
