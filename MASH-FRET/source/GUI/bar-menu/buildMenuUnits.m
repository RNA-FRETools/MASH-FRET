function h = buildMenuUnits(h)
% Create sub-menus of "Units" menu in menubar.
%
% h = buildMenuUnits(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.figure_MASH: handle to main figure
% h.menu_units: handle to menu "Units"

% created by MH, 29.10.2021

% default
lbl0 = 'Time';
lbl1 = 'Intensities';

% parents
h_men = h.menu_units;

% GUI
h.menu_time = uimenu(h_men,'label',lbl0);
h = buildMenuTime(h);

h.menu_intensities = uimenu(h_men,'label',lbl1);
h = buildMenuIntensities(h);
