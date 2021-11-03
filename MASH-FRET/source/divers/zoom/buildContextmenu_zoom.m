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
chld = h_fig.Children;
h_axes = [];
for h_c = chld'
    if isprop(h_c,'Type') && strcmp(h_c.Type,'axes')
        h_axes = cat(2,h_axes,h_c);
    end
end
set(h_axes,'uicontextmenu',h_cm);

