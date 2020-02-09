function checkbox_bgCorrAll_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

p.movBg_one = ~get(obj, 'Value');
if p.movBg_one
    p.movBg_one = h.movie.frameCurNb;
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);