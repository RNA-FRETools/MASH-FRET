function pushbutton_loadMov_Callback(obj, evd, h_fig)

h = guidata(h_fig);
if isfield(h, 'movie') && isfield(h.movie, 'path') && ...
        exist(h.movie.path, 'dir')
    cd(h.movie.path);
end

% improt video
if ~loadMovFile('all','Select a graphic file:',1,h_fig);
    return
end

h = guidata(h_fig);
p = h.param.movPr;

% set video file for intensity integration
p.itg_movFullPth = [h.movie.path h.movie.file];

% set frame acquisition time
p.rate = h.movie.cyctime;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
