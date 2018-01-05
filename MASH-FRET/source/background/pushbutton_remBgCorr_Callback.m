function pushbutton_remBgCorr_Callback(obj, evd, h)
oldCorr = h.param.movPr.bgCorr;
k = 1;
h.param.movPr.bgCorr = {};
line2rm = get(h.listbox_bgCorr, 'Value');
for i=1:size(oldCorr,1)
    if i ~= line2rm
        for j = 1:size(oldCorr,2)
            h.param.movPr.bgCorr{k,j} = oldCorr{i,j};
        end
        k = k + 1;
    end
end
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'imgAxes');