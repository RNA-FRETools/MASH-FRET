function pushbutton_loadMov_Callback(obj, evd, h_fig)
% pushbutton_loadMov_Callback([], [], h_fig)
% pushbutton_loadMov_Callback(videofile, [], h_fig)
%
% h_fig: handle to main figure
% videofile: source video/image file

h = guidata(h_fig);
if isfield(h, 'movie') && isfield(h.movie, 'path') && ...
        exist(h.movie.path, 'dir')
    cd(h.movie.path);
end

% import video
if iscell(obj)
    argin = obj;
else
    argin = 'Select a graphic file:';
end
if ~loadMovFile('all',argin,1,h_fig);
    return
end

h = guidata(h_fig);
p = h.param.movPr;

% set video file for intensity integration
p.itg_movFullPth = [h.movie.path h.movie.file];

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
