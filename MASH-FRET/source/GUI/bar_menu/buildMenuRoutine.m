function h = buildMenuRoutine(h)
% Creates sub-menus of "Routine" menu in menubar.
%
% h = buildMenuRoutine(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
% h.figure_MASH: handle to main figure
% h.menu_routine: handle to menu "Routine"

% created by MH, 11.10.2019

% default
lbl0 = 'routine 01';
lbl1 = 'routine 02';
lbl2 = 'routine 03';
lbl3 = 'routine 04';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_routine;

% GUI
h.menu_routine1 = uimenu(h_men,'label',lbl0,'callback',...
    {@ttPr_routine,1,h_fig});

h.menu_routine2 = uimenu(h_men,'label',lbl1,'callback',...
    {@ttPr_routine,2,h_fig});

h.menu_routine3 = uimenu(h_men,'label',lbl2,'callback',...
    {@ttPr_routine,3,h_fig});

h.menu_routine4 = uimenu(h_men,'label',lbl3,'callback',...
    {@ttPr_routine,4,h_fig});
