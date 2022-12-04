function h = buildMenuTime(h)
% Creates sub-menus of "Time" menu in menubar.
%
% h = buildMenuTime(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.figure_MASH: handle to main figure
% h.menu_time: handle to menu "Time"

% created by MH, 29.10.2021

% default
lbl0 = 'in seconds';
lbl1 = 'in sampling steps (frames)';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_time;

% GUI
h.menu_inSec = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_units_Callback,h_fig},'checked','off');

h.menu_inFrame = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_units_Callback,h_fig},'checked','off');
