function h = buildMenuSampleManagement(h)
% Creates sub-menus of "panel Sample management" menu in menubar.
%
% h = buildMenuSampleManagement(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_TP_sampleManagementTest: handle to menu "panel Sample management"

% created by MH, 07.02.2020

% default
lbl0 = 'All';
lbl1 = 'File export';
lbl2 = 'Trace manager';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_TP_sampleManagementTest;

% GUI
h.menu_TP_allSampleManagement = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'tp','sample management',h_fig});

h.menu_TP_fileExport = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_routineTest_Callback,'tp','file export',h_fig});

h.menu_TP_traceManager = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_routineTest_Callback,'tp','trace manager',h_fig});
