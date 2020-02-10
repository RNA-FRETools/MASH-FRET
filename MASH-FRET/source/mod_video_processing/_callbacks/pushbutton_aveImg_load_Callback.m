function pushbutton_aveImg_load_Callback(obj, evd, h_fig)

cd(setCorrectPath('average_images', h_fig));

if loadMovFile(1,'Select a graphic file:', 1, h_fig);
    
    % collect interface parameters
    h = guidata(h_fig);
    p = h.param.movPr;
    
    p.itg_movFullPth = [h.movie.path h.movie.file];
    p.rate = h.movie.cyctime;
    
    % save modifications
    h.param.movPr = p;
    guidata(h_fig, h);
    
    % refresh calculations, plot and set GUI to proper values
    updateFields(h_fig, 'imgAxes');
end