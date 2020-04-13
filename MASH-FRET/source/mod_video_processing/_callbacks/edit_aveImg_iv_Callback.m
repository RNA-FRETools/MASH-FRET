function edit_aveImg_iv_Callback(obj, evd, h_fig)

% collect interface parameters
val = round(str2double(get(obj, 'String')));
h = guidata(h_fig);

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Frame interval must be >= 1.', h_fig, 'error');
    return
end

h.param.movPr.ave_iv = val;

% save modifications
guidata(h_fig, h);

% set GUI to proper values
ud_VP_molCoordPan(h_fig);