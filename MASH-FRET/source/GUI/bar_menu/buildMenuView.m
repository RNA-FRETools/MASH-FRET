function h = buildMenuView(h)
% Create sub-menus of "View" menu in menubar.
%
% h = buildMenuView(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.figure_MASH: handle to main figure
% h.menu_view: handle to menu "View"

% created by MH, 11.10.2019

% default
lbl0 = 'History';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_view;

% GUI
h.menu_showActPan = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_showActPan_Callback,h_fig},'checked','on');