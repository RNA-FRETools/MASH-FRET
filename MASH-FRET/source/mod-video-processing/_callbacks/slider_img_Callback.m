function slider_img_Callback(obj, evd, h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;

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

% update current video frame
p.movPr.curr_frame(proj) = l;

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
