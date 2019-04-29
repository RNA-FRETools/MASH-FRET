function pushbutton_aveImg_load_Callback(obj, evd, h)
cd(setCorrectPath('average_images', h.figure_MASH));
loadMovFile(1, 'Select a graphic file:', 1, h.figure_MASH);