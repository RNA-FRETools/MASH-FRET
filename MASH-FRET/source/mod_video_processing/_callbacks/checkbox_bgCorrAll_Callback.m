function checkbox_bgCorrAll_Callback(obj, evd, h)
h.param.movPr.movBg_one = ~get(obj, 'Value');
if h.param.movPr.movBg_one
    h.param.movPr.movBg_one = h.movie.frameCurNb;
end
guidata(h.figure_MASH, h);