function h = buildMenuBackground(h)
% Creates sub-menus of "panel Background" menu in menubar.
%
% h = buildMenuBackground(h)
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.figure_MASH: handle to main figure
%  h.menu_TP_backgroundTest: handle to menu "panel Background"

% created by MH, 07.02.2020

% default
lbl0 = 'All';
lbl1 = 'Background corrections';
lbl2 = 'Background analyzer';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_TP_backgroundTest;

% GUI
h.menu_TP_allBackground = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'tp','background',h_fig});

h.menu_TP_backgroundCorrections = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_routineTest_Callback,'tp','background corrections',h_fig});

h.menu_TP_backgroundAnalyzer = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_routineTest_Callback,'tp','background analyzer',h_fig});
