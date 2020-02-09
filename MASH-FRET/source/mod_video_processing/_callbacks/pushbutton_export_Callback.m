function pushbutton_export_Callback(obj, evd, h_fig)

h = guidata(h_fig);
if ~isfield(h, 'movie')
    return
end

if isfield(h.movie, 'path') && exist(h.movie.path, 'dir')
    cd(h.movie.path);
end
exportMovie(h_fig);
