function pushbutton_loadMov_Callback(obj, evd, h)
if isfield(h, 'movie') && isfield(h.movie, 'path') && ...
        exist(h.movie.path, 'dir')
    cd(h.movie.path);
end
if loadMovFile(1, 'Select a graphic file:', 1, h.figure_MASH);
    h = guidata(h.figure_MASH);
    h.param.movPr.itg_movFullPth = [h.movie.path h.movie.file];
    h.param.movPr.rate = h.movie.cyctime;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'imgAxes');
end