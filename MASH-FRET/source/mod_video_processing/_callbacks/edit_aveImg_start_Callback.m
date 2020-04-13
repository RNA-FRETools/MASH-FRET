function edit_aveImg_start_Callback(obj, evd, h_fig)

% collect interface parameters
val = round(str2double(get(obj, 'String')));
h = guidata(h_fig);
p =  h.param.movPr;

% collect processing parameters
stop = p.ave_stop;

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val<=stop && val>=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Starting frame must be <= ending frame and >= 1.', ...
        h_fig, 'error');
    return
end

p.ave_start = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_molCoordPan(h_fig);
