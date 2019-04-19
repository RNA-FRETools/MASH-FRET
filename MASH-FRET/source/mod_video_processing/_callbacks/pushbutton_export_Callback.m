function pushbutton_export_Callback(obj, evd, h)
% Set fields to proper values
updateFields(h.figure_MASH, 'movPr');
if isfield(h, 'movie')
    if isfield(h.movie, 'path') && exist(h.movie.path, 'dir')
        cd(h.movie.path);
    end
    exportMovie(h.figure_MASH);
end