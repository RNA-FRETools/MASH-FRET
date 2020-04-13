function edit_endMov_Callback(obj, evd, h_fig)

% get interface parameters
val = round(str2num(get(obj, 'String')));
h = guidata(h_fig);
p = h.param.movPr;

% get video parameters
tot = h.movie.framesTot;

% get processing parameters
start = p.mov_start;

set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= start && ...
        val <= tot)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Ending frame must be >= starting frame and <= ' ...
        'frame length.'], h_fig, 'error');
    return
end

p.mov_end = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_edExpVidPan(h_fig)

