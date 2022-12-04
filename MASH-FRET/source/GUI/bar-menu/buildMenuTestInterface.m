function h = buildMenuTestInterface(h)
% Creates sub-menus of "Test interface" menu in menubar.
%
% h = buildMenuTestInterface(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.figure_MASH: handle to main figure
%  h.menu_testInterface: handle to menu "Test interface"

% created by MH, 3.3.2020

% default
lbl0 = 'Simulation test';
lbl1 = 'Video processing test';
lbl2 = 'Trace processing test';
lbl3 = 'Histogram analysis test';
lbl4 = 'Transition analysis test';
lbl5 = 'Menu test';

% parents
h_men = h.menu_testInterface;

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

h.menu_menuTest = uimenu(h_men,'label',lbl5);
h = buildMenuMenuTest(h);
