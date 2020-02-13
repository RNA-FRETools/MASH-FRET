function h = buildMenuSimulationTest(h)
% Creates sub-menus of "Simulation test" menu in menubar.
%
% h = buildMenuSimulationTest(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_SimTest: handle to menu "Simulation test"

% created by MH, 07.02.2020

% default
lbl0 = 'All panels';
lbl1 = 'panel "Video parameters"';
lbl2 = 'panel "Molecules"';
lbl3 = 'panel "Experimental setup"';
lbl4 = 'panel "Export options"';
lbl5 = 'visualization area';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_SimTest;

% GUI
h.menu_S_allTest = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'sim','all',h_fig});

h.menu_S_videoParametersTest = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_routineTest_Callback,'sim','video parameters',h_fig});

h.menu_S_moleculesTest = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_routineTest_Callback,'sim','molecules',h_fig});

h.menu_S_experimentalSetupTest = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_routineTest_Callback,'sim','experimental setup',h_fig});

h.menu_S_exportOptionsTest = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_routineTest_Callback,'sim','export options',h_fig});

h.menu_S_visualizationArea = uimenu(h_men,'label',lbl5,'callback',...
    {@menu_routineTest_Callback,'sim','visualization area',h_fig});
