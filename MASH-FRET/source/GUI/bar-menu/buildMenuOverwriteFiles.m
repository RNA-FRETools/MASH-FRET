function h = buildMenuOverwriteFiles(h)
% Creates sub-menus of "Overwrite files" menu in menubar.
%
% h = buildMenuOverwriteFiles(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.figure_MASH: handle to main figure
% h.menu_overwriteFiles: handle to menu "Overwrite files"

% created by MH, 11.10.2019

% default
lbl0 = 'Overwrite files';
lbl1 = 'Rename files (numbered file name)';
lbl2 = 'Always ask';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_overwriteFiles;

% GUI
h.menu_overWrite = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_overwrite_Callback,h_fig});

h.menu_rename = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_overwrite_Callback,h_fig});

h.menu_ask = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_overwrite_Callback,h_fig},'checked','on');
