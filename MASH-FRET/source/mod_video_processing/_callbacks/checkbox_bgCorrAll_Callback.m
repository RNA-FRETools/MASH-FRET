function checkbox_bgCorrAll_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h.param.movPr.movBg_one = ~get(obj, 'Value');
if h.param.movPr.movBg_one
    h.param.movPr.movBg_one = h.movie.frameCurNb;
end
guidata(h_fig, h);