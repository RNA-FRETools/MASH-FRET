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
    if isfield(h,'axes_VP_vid') && sum(ishandle(h.axes_VP_vid))
        set([h.axes_VP_vid,h.cb_VP_vid,h.axes_VP_avimg,h.cb_VP_avimg],...
            'visible','off');
    end
    return
end

% retrieve parameters
proj = p.curr_proj;
curr = p.proj{proj}.VP.curr;
l = p.movPr.curr_frame(proj);
inSec = p.proj{proj}.time_in_sec;
expT = p.proj{proj}.sampling_time;
chansplit = curr.plot{2};

% control video
if ~p.proj{proj}.is_movie
    return
end

nVid = numel(p.proj{proj}.movie_file);
for vid = 1:nVid
    
    % retrieve current video display
    L = p.proj{proj}.movie_dat{vid}{3};
    resX = p.proj{proj}.movie_dat{vid}{2}(1);
    resY = p.proj{proj}.movie_dat{vid}{2}(2);
    vidFile = p.proj{proj}.movie_file{vid};

    % set video file
    set(h.edit_movFile(vid), 'String', vidFile);

    % set video dimensions
    set(h.text_movW(vid), 'String', num2str(resX));
    set(h.text_movH(vid), 'String', num2str(resY));
end

% adjust channel splitting
txt_split = '';
if nVid==1
    for i = 1:size(chansplit,2)
        txt_split = cat(2,txt_split,' ',num2str(chansplit(i)));
    end
    txt_split = ['Channel splitting: ' txt_split];
end
set(h.text_split, 'String', txt_split);

% Update slider properties & position 
if L>0
    set(h.slider_img, 'SliderStep',[1/L max(1/L,0.1)],'Min',1,'Max',L,...
        'Value',l,'Visible','on');
end
if L<=1
    set(h.slider_img,'Visible','off');
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


