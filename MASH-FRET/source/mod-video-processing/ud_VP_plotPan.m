function ud_VP_plotPan(h_fig)
% ud_VP_plotPan(h_fig)
%
% Set panel "Plot" in module Video processing to proper values
%
% h_fig: handle to main figure

% defaults
memClr = [1,0.6,0.6];

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% set all uicontrol enabled
set([h.edit_movFile,h.text_frameCurr,h.text_frameEnd,h.text_movW,...
    h.text_movH,h.text_split,h.slider_img],'enable','on','visible','on');

% reset edit fields background color
set(h.edit_movFile,'backgroundcolor',[1,1,1]);

% collect video parameters
isMov = isfield(h,'movie');

% set color map menu
set(h.popupmenu_colorMap, 'Value', p.cmap);
str_map = get(h.popupmenu_colorMap,'string');
cm = colormap(eval(lower(str_map{p.cmap})));
colormap(h.axes_movie,cm);

% set image count units
set(h.checkbox_int_ps, 'Value', p.perSec);

if isMov
    % collect video parameters
    l = h.movie.frameCurNb;
    L = h.movie.framesTot;
    resX = h.movie.pixelX;
    resY = h.movie.pixelY;
    vidFile = h.movie.file;
    chansplit = h.movie.split;
    isFullMov = false;
    if isfield(h.movie,'movie') && ~isempty(h.movie.movie);
        isFullMov = true;
    end

    % adjust channel splitting
    txt_split = [];
    for i = 1:size(chansplit,2)
        txt_split = cat(2,txt_split,' ',num2str(chansplit(i)));
    end
    set(h.text_split, 'String', ['Channel splitting: ' txt_split]);
    
    % set "Free" button color
    if isFullMov
        set(h.pushbutton_VP_freeMem, 'backgroundcolor', memClr);
    end
    
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
end



