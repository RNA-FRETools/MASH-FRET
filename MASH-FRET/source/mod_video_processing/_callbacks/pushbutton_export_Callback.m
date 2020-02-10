function ok = pushbutton_export_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);

if ~isfield(h, 'movie')
    return
end

% export video/image
if isfield(h.movie, 'path') && exist(h.movie.path, 'dir')
    cd(h.movie.path);
end
exportMovie(h_fig);

