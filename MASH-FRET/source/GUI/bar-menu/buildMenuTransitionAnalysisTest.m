function h = buildMenuTransitionAnalysisTest(h)
% Creates sub-menus of "Transition analysis test" menu in menubar.
%
% h = buildMenuTransitionAnalysisTest(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_TaTest: handle to menu "Transition analysis test"

% created by MH, 07.02.2020

% default
lbl0 = 'All panels';
lbl1 = 'project management area';
lbl2 = 'panel "Transition density plot"';
lbl3 = 'panel "State configuration"';
lbl4 = 'panel "State lifetimes"';
lbl5 = 'panel "Kinetic model"';
lbl6 = 'visualization area';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_TaTest;

% GUI
h.menu_TA_allTest = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'ta','all',h_fig});

h.menu_TA_projectManagementTest = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_routineTest_Callback,'ta','project management',h_fig});

h.menu_TA_transitionDensityPlotTest = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_routineTest_Callback,'ta','transition density plot',h_fig});

h.menu_TA_stateConfigurationTest = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_routineTest_Callback,'ta','state configuration',h_fig});

h.menu_TA_stateTranditionRatesTest = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_routineTest_Callback,'ta','state lifetimes',h_fig});

h.menu_TA_kineticModelTest = uimenu(h_men,'label',lbl5,'callback',...
    {@menu_routineTest_Callback,'ta','kinetic model',h_fig});

h.menu_TA_visualizationAreaTest = uimenu(h_men,'label',lbl6,'callback',...
    {@menu_routineTest_Callback,'ta','visualization area',h_fig});
