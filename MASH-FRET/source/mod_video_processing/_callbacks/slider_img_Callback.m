function slider_img_Callback(obj, evd, h)
cursorPos = round(get(obj, 'Value'));
minSlider = get(obj, 'Min');
maxSlider = get(obj, 'Max');
if cursorPos <= minSlider
    cursorPos = minSlider;
elseif cursorPos >= maxSlider
    cursorPos = maxSlider;
end
set(obj, 'Value', cursorPos);
set(h.text_frameCurr, 'String', cursorPos);

[data,ok] = getFrames([h.movie.path h.movie.file], cursorPos, ...
    {h.movie.speCursor [h.movie.pixelX h.movie.pixelY] ...
    h.movie.framesTot}, h.figure_MASH);
if ok
    p = h.param.movPr;
    if size(p.SFres,1) >= 1
        p.SFres = p.SFres(1,1:(1+p.nChan));
    end
    h.param.movPr = p;
    h.movie.frameCurNb = cursorPos;
    h.movie.frameCur = data.frameCur;
    guidata(h.figure_MASH, h);
end
updateFields(h.figure_MASH, 'imgAxes');