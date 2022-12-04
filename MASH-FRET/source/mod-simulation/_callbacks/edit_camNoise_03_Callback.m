function edit_camNoise_03_Callback(obj, evd, h_fig)

% retrieve noise parameter from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>=0 && val<=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Total Detection Efficiency must be comprised ' ...
        'between 0 and 1'], 'error', h_fig);
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;
ind = get(h.popupmenu_noiseType, 'Value');

p.proj{p.curr_proj}.sim.curr.gen_dat{1}{2}{5}(ind,3) = val;

h.param = p;
guidata(h_fig,h);

% refresh panel
ud_S_vidParamPan(h_fig);