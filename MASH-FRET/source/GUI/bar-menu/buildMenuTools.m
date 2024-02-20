function h = buildMenuTools(h)
% Creates sub-menus of "Tools" menu in menubar.
%
% h = buildMenuTools(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.menu_tools: handle to menu "Overwrite files"

% created by MH, 07.01.2019

% default
lbl0 = 'Restructure files';
lbl2 = 'Check toolbox dependencies';

% parents
h_men = h.menu_tools;

% GUI
h.menu_restructFiles = uimenu(h_men,'label',lbl0,'callback',...
    @menu_restructFiles_Callback);

h.menu_toolboxDependency = uimenu(h_men,'label',lbl2);
h = buildMenuToolboxDependency(h);

