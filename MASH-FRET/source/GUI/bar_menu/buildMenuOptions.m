function h = buildMenuOptions(h)
% Create sub-menus of "Options" menu in menubar.
%
% h = buildMenuOptions(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.figure_MASH: handle to main figure
% h.menu_options: handle to menu "Options"

% created by MH, 11.10.2019

% default
lbl0 = 'Overwrite files';

% parents
h_men = h.menu_options;

% GUI
h.menu_overwriteFiles = uimenu(h_men,'label',lbl0);
h = buildMenuOverwriteFiles(h);
