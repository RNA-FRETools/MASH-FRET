function pushbutton_loadMov_Callback(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'movie') && isfield(h.movie, 'path') && ...
        exist(h.movie.path, 'dir')
    cd(h.movie.path);
end
if loadMovFile('all','Select a graphic file:',1,h_fig);
    h = guidata(h_fig);
    h.param.movPr.itg_movFullPth = [h.movie.path h.movie.file];
    h.param.movPr.rate = h.movie.cyctime;
    guidata(h_fig, h);
    updateFields(h_fig, 'imgAxes');
end