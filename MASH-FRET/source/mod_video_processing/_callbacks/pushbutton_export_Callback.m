function pushbutton_export_Callback(obj, evd, h_fig)
% Set fields to proper values
updateFields(h_fig, 'movPr');
h = guidata(h_fig);
if isfield(h, 'movie')
    if isfield(h.movie, 'path') && exist(h.movie.path, 'dir')
        cd(h.movie.path);
    end
    exportMovie(h_fig);
end