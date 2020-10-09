function slider_img_Callback(obj, evd, h_fig)
cursorPos = round(get(obj, 'Value'));
minSlider = get(obj, 'Min');
maxSlider = get(obj, 'Max');
if cursorPos <= minSlider
    cursorPos = minSlider;
elseif cursorPos >= maxSlider
    cursorPos = maxSlider;
end

h = guidata(h_fig);
set(obj, 'Value', cursorPos);
set(h.text_frameCurr, 'String', cursorPos);

[data,ok] = getFrames([h.movie.path h.movie.file], cursorPos, ...
    {h.movie.speCursor [h.movie.pixelX h.movie.pixelY] ...
    h.movie.framesTot}, h_fig, true);
if ok
    p = h.param.movPr;
    if size(p.SFres,1) >= 1
        p.SFres = p.SFres(1,1:(1+p.nChan));
    end
    h.param.movPr = p;
    h.movie.frameCurNb = cursorPos;
    h.movie.frameCur = data.frameCur;
    guidata(h_fig, h);
end
updateFields(h_fig, 'imgAxes');
