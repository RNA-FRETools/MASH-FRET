function h = buildMenuMenuTest(h)
% Creates sub-menus of "Menu test" menu in menubar.
%
% h = buildMenuTraceProcessingTest(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_menuTest: handle to menu "Menu test"

% created by MH, 07.02.2020

% default
lbl0 = 'All menus';
lbl2 = 'menu "Options"';
lbl3 = 'menu "Tools"';
lbl4 = 'menu "Units"';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_menuTest;

% GUI
h.menu_menu_allTest = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'menu','all',h_fig});

h.menu_menu_optionsTest = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_routineTest_Callback,'menu','options',h_fig});

h.menu_menu_toolsTest = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_routineTest_Callback,'menu','tools',h_fig});

h.menu_menu_unitsTest = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_routineTest_Callback,'menu','units',h_fig});
