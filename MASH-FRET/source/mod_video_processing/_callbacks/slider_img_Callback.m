function slider_img_Callback(obj, evd, h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% get video parameters
videoFile = [h.movie.path h.movie.file];
fcurs = h.movie.speCursor;
resX = h.movie.pixelX;
resY = h.movie.pixelY;
L = h.movie.framesTot;

% adjust slider position
l = round(get(obj, 'Value'));
minSlider = get(obj, 'Min');
maxSlider = get(obj, 'Max');
if l <= minSlider
    l = minSlider;
elseif l >= maxSlider
    l = maxSlider;
end
set(obj, 'Value', l);

% read corresponding video frame
[data,ok] = getFrames(videoFile, l, {fcurs [resX resY] L}, h_fig, true);
if ~ok
    return
end

% update current video frame
h.movie.frameCurNb = l;
h.movie.frameCur = data.frameCur;

% reset SF results
if size(p.SFres,1) >= 1
    p.SFres = p.SFres(1,1:(1+p.nChan));
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
