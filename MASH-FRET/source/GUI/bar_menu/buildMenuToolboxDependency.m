function h = buildMenuToolboxDependency(h)
% Creates sub-menus of "Toolbox dependency" menu in menubar.
%
% h = buildMenuToolboxDependency(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.menu_toolboxDependency: handle to menu "Overwrite files"

% created by MH, 07.01.2019

% default
lbl0 = 'Discovery mode';
lbl1 = 'Analysis mode';

% parents
h_men = h.menu_toolboxDependency;

% GUI
h.menu_discoveryMode = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_toolboxDependency_Callback,'discovery'});

h.menu_analysisMode = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_toolboxDependency_Callback,'analysis'});