function edit_rate_Callback(obj, evd, h_fig)

% collect interface parameters
val = str2double(get(obj, 'String'));
h = guidata(h_fig);
p = h.param.movPr;

set(obj, 'String', val);
if ~(numel(val)==1 && ~isnan(val) && val>0)
    updateActPan('Frame rate must be > 0.', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

if isfield(h,'movie') && isfield(h.movie,'cyctime')
    % set video parameters
    h.movie.cyctime = val;
end

% set processing parameters
p.rate = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);
    
% set GUI to proper values and refresh plot
updateFields(h_fig, 'imgAxes');
