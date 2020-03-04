function h = buildMenuRoutine(h)
% Creates sub-menus of "Routine" menu in menubar.
%
% h = buildMenuRoutine(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.figure_MASH: handle to main figure
%  h.menu_routine: handle to menu "Routine"

% created by MH, 11.10.2019

% default
lbl0 = 'Test interface';
lbl1 = 'Kinsoft challenge';

% parents
h_men = h.menu_routine;

% GUI
h.menu_testInterface = uimenu(h_men,'label',lbl0);
h = buildMenuTestInterface(h);

h.menu_kinsoftChallenge = uimenu(h_men,'label',lbl1);
h = buildMenuKinsoftChallenge(h);

