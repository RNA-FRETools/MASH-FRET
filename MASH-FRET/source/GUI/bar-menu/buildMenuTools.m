function h = buildMenuTools(h)
% Creates sub-menus of "Tools" menu in menubar.
%
% h = buildMenuTools(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.menu_tools: handle to menu "Tools"

% created by MH, 07.01.2019

% default
lbl0 = 'Check toolbox dependencies';

% parents
h_men = h.menu_tools;

% GUI
h.menu_toolboxDependency = uimenu(h_men,'label',lbl0);
h = buildMenuToolboxDependency(h);

