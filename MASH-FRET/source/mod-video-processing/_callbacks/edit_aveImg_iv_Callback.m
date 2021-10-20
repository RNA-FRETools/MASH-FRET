function edit_aveImg_iv_Callback(obj, evd, h_fig)

% retrieve edit field value
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Frame interval must be >= 1.', h_fig, 'error');
    return
end

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% save frame interval for average image calculation
p.proj{p.curr_proj}.VP.curr.gen_crd{1}(3) = val;

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_molCoordPan(h_fig);
