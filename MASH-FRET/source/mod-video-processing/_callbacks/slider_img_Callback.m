function slider_img_Callback(obj, evd, h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;

% get video parameters
videoFile = p.proj{proj}.movie_file;
fcurs = p.proj{proj}.movie_dat{1};
resX = p.proj{proj}.movie_dim(1);
resY = p.proj{proj}.movie_dim(2);
L = p.proj{proj}.movie_dat{3};

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
p.movPr.curr_frame(proj) = l;
p.proj{proj}.VP.curr_img = data.frameCur;

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
