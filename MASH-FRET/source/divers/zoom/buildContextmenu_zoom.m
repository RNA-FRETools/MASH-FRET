function h = buildContextmenu_zoom(h)

% default
lbl0 = 'Reset to original view';
lbl1 = 'Zoom tool';
lbl2 = 'Pan tool';
lbl3 = 'Export graph';

h_fig = h.figure_MASH;

% build and add context menus
h.cm_zoom = uicontextmenu('parent',h_fig);
h_cm = h.cm_zoom;
uimenu('parent',h_cm,'label',lbl0,'callback',{@ud_zoom,'reset',h_fig});
h.zMenu_zoom = uimenu('parent',h_cm,'label',lbl1,'callback',...
    {@ud_zoom,'zoom',h_fig},'checked','on');
h.zMenu_pan = uimenu('parent',h_cm,'label',lbl2,'callback',...
    {@ud_zoom,'pan',h_fig},'checked','off');
h.zMenu_exp = uimenu('parent',h_cm,'label',lbl3,'callback',...
    {@exportAxes,h_fig});

% apply context menu to pan tool
h.TTpan = pan(h_fig);
set(h.TTpan, 'actionpostcallback',{@ud_axesLim,h_fig},'uicontextmenu',...
    h_cm,'enable','off');

% apply context menu to zoom tool
h.TTzoom = zoom(h_fig);
set(h.TTzoom,'actionpostcallback',{@ud_axesLim,h_fig},'rightclickaction',...
    'postcontextmenu','uicontextmenu',h_cm,'enable','on');

% set context menu to all axes
set([h.axes_example_mov,h.axes_example_hist,h.axes_example,h.axes_movie,...
    h.axes_bottom,h.axes_bottomRight,h.axes_top,h.axes_topRight,...
    h.axes_thm_BIC,h.axes_hist1,h.axes_hist2,h.axes_tdp_BIC,...
    h.axes_TDPplot1,h.axes_TDPplot2],'uicontextmenu',h_cm);

