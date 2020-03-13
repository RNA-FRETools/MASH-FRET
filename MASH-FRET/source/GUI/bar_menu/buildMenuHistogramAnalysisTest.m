function h = buildMenuHistogramAnalysisTest(h)
% Creates sub-menus of "Histogram analysis test" menu in menubar.
%
% h = buildMenuHistogramAnalysisTest(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_HaTest: handle to menu "Histogram analysis test"

% created by MH, 07.02.2020

% default
lbl0 = 'All panels';
lbl1 = 'project management area';
lbl2 = 'panel "Histogram and plot"';
lbl3 = 'panel "State configuration"';
lbl4 = 'panel "State populations"';
lbl5 = 'visualization area';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_HaTest;

% GUI
h.menu_HA_allTest = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'ha','all',h_fig});

h.menu_HA_projectManagementTest = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_routineTest_Callback,'ha','project management',h_fig});

h.menu_HA_histogramAndPlotTest = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_routineTest_Callback,'ha','histogram and plot',h_fig});

h.menu_HA_stateConfigurationTest = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_routineTest_Callback,'ha','state configuration',h_fig});

h.menu_HA_statePopulationsTest = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_routineTest_Callback,'ha','state populations',h_fig});

h.menu_HA_visualizationTest = uimenu(h_men,'label',lbl5,'callback',...
    {@menu_routineTest_Callback,'ha','visualization',h_fig});

