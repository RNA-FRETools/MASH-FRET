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
lbl0 = 'Simulation test';
lbl1 = 'Video processing test';
lbl2 = 'Trace processing test';
lbl3 = 'Histogram analysis test';
lbl4 = 'Transition analysis test';

% parents
h_men = h.menu_routine;

% GUI
h.menu_SimTest = uimenu(h_men,'label',lbl0);
h = buildMenuSimulationTest(h);

h.menu_VpTest = uimenu(h_men,'label',lbl1);
h = buildMenuVideoProcessingTest(h);

h.menu_TpTest = uimenu(h_men,'label',lbl2);
h = buildMenuTraceProcessingTest(h);

h.menu_HaTest = uimenu(h_men,'label',lbl3);
h = buildMenuHistogramAnalysisTest(h);

h.menu_TaTest = uimenu(h_men,'label',lbl4);
h = buildMenuTransitionAnalysisTest(h);
