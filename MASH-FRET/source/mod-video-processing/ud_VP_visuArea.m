function ud_VP_visuArea(h_fig)
% ud_VP_visuArea(h_fig)
%
% Set visualization area in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uitabgroup_VP_plot,h)
    set([h.axes_VP_vid,h.cb_VP_vid,h.axes_VP_avimg,h.cb_VP_avimg],...
        'visible','off');
    return
end

% retrieve parameters
proj = p.curr_proj;
curr = p.proj{proj}.VP.curr;
l = p.movPr.curr_frame(proj);
L = p.proj{proj}.movie_dat{3};
resX = p.proj{proj}.movie_dat{2}(1);
resY = p.proj{proj}.movie_dat{2}(2);
vidFile = p.proj{proj}.movie_file;
inSec = p.proj{proj}.time_in_sec;
expT = p.proj{proj}.frame_rate;
chansplit = curr.plot{2};

% control video
if ~p.proj{proj}.is_movie
    return
end

% adjust channel splitting
txt_split = [];
for i = 1:size(chansplit,2)
    txt_split = cat(2,txt_split,' ',num2str(chansplit(i)));
end
set(h.text_split, 'String', ['Channel splitting: ' txt_split]);

% set video file
set(h.edit_movFile, 'String', vidFile);

% Update slider properties & position     
if L<=1
    set(h.slider_img,'Visible','off');
else
    set(h.slider_img, 'SliderStep',[1/L max(1/L,0.1)],'Min',1,'Max',L,...
        'Value',l,'Visible','on');
end

% set video descriptions
if inSec
    l = l*expT;
    L = L*expT;
    set(h.text_frame,'string','Time');
    set(h.text_frameUnits,'string','s');
else
    set(h.text_frame,'string','Frame');
    set(h.text_frameUnits,'string','');
end
set(h.text_frameEnd, 'String', num2str(L));
set(h.text_frameCurr, 'String', num2str(l));
set(h.text_movW, 'String', num2str(resX));
set(h.text_movH, 'String', num2str(resY));


