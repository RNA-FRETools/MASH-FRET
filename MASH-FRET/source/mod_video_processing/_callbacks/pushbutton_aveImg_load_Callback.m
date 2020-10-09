function pushbutton_aveImg_load_Callback(obj, evd, h_fig)
cd(setCorrectPath('average_images', h_fig));
if loadMovFile(1,'Select a graphic file:', 1, h_fig);
    h = guidata(h_fig);
    h.param.movPr.itg_movFullPth = [h.movie.path h.movie.file];
    h.param.movPr.rate = h.movie.cyctime;
    guidata(h_fig, h);
    updateFields(h_fig, 'imgAxes');
end