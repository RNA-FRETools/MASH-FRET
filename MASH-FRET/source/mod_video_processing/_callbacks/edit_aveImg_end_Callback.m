function edit_aveImg_end_Callback(obj, evd, h_fig)

% collect interface parameters
val = round(str2double(get(obj, 'String')));
h = guidata(h_fig);
p =  h.param.movPr;

% collect video parameters
L = h.movie.framesTot;

% collect processing parameters
start = p.ave_start;

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=start && val<=L)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Ending frame must be >= starting frame and <= ' ...
        'frame length.'], h_fig, 'error');
    return
end

p.ave_stop = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_molCoordPan(h_fig);
