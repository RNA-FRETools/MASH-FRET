function ud_VP_plotPan(h_fig)
% ud_VP_plotPan(h_fig)
%
% Set panel "Plot" in module Video processing to proper values
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

% collect experiment settings and video parameters
proj = p.curr_proj;
curr = p.proj{proj}.VP.curr;

% set color map menu
set(h.popupmenu_colorMap, 'Value', curr.plot{1}(2));
str_map = get(h.popupmenu_colorMap,'string');
cm = colormap(eval(lower(str_map{curr.plot{1}(2)})));
colormap(h.axes_VP_vid,cm);

% set image count units
set(h.checkbox_int_ps, 'Value', curr.plot{1}(1));

if ~p.proj{proj}.is_movie
    return
end

% collect video parameters
l = p.movPr.curr_frame(proj);
L = p.proj{proj}.movie_dat{3};
resX = p.proj{proj}.movie_dat{2}(1);
resY = p.proj{proj}.movie_dat{2}(2);
vidFile = p.proj{proj}.movie_file;
chansplit = curr.plot{2};

% adjust channel splitting
txt_split = [];
for i = 1:size(chansplit,2)
    txt_split = cat(2,txt_split,' ',num2str(chansplit(i)));
end
set(h.text_split, 'String', ['Channel splitting: ' txt_split]);

% set video file
set(h.edit_movFile, 'String', vidFile);

% set video descriptions
set(h.text_frameEnd, 'String', num2str(L));
set(h.text_frameCurr, 'String', num2str(l));
set(h.text_movW, 'String', num2str(resX));
set(h.text_movH, 'String', num2str(resY));

% Update slider properties & position     
if L<=1
    set(h.slider_img,'Visible','off');
else
    set(h.slider_img, 'SliderStep',[1/L max(1/L,0.1)],'Min',1,'Max',L,...
        'Value',l,'Visible','on');
end




