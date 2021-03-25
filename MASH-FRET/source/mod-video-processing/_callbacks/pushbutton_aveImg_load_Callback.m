function pushbutton_aveImg_load_Callback(obj, evd, h_fig)
% pushbutton_aveImg_load_Callback([],[],h_fig)
% pushbutton_aveImg_load_Callback(aveimgfile,[],h_fig)
%
% h_fig: handle to main figure
% aveimgfile: {1-by-2} source folder and file for average image

% get destination image file
if iscell(obj)
    argin = obj;
else
    cd(setCorrectPath('average_images', h_fig));
    argin = 'Select a graphic file:';
end
if ~loadMovFile(1, argin, 1, h_fig);
    return
end

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
