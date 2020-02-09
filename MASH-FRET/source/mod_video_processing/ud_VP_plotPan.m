function ud_VP_plotPan(h_fig)
% ud_VP_plotPan(h_fig)
%
% Set panel "Plot" in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% set all uicontrol enabled
setProp(h.uipanel_VP_plot,'enable','on');

% collect video parameters
isMov = isfield(h,'movie');

% set color map menu
set(h.popupmenu_colorMap, 'Value', p.cmap);

% set image count units
set(h.checkbox_int_ps, 'Value', p.perSec);

% set video descriptions
l = get(h.slider_img,'position');
set(h.text_frameCurr, 'String', num2str(l));

% adjust channel splitting
if isMov
    chansplit = h.movie.split;
    txt_split = [];
    for i = 1:size(chansplit,2)
        txt_split = cat(2,txt_split,' ',num2str(chansplit(i)));
    end
    set(h.text_split, 'String', ['Channel splitting: ' txt_split]);
end



