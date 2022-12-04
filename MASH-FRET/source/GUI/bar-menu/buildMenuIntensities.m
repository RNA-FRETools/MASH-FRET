function h = buildMenuIntensities(h)
% Creates sub-menus of "Intensities" menu in menubar.
%
% h = buildMenuIntensities(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.figure_MASH: handle to main figure
% h.menu_intensities: handle to menu "Intensities"

% created by MH, 29.10.2021

% default
lbl0 = 'per seconds';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_intensities;

% GUI
h.menu_perSec = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_units_Callback,h_fig},'checked','off');
