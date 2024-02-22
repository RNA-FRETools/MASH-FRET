function h = buildMenuTraceProcessingTest(h)
% Creates sub-menus of "Trace processing test" menu in menubar.
%
% h = buildMenuTraceProcessingTest(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_TpTest: handle to menu "Trace processing test"

% created by MH, 07.02.2020

% default
lbl0 = 'All panels';
lbl1 = 'project management area';
lbl2 = 'panel "Sample management"';
lbl3 = 'panel "Plot"';
lbl4 = 'panel "Sub-images"';
lbl5 = 'panel "Background"';
lbl6 = 'panel "Re-sampling"';
lbl7 = 'panel "Cross-talks"';
lbl8 = 'panel "Denoising"';
lbl9 = 'panel "Photobleaching"';
lbl10 = 'panel "Factor corrections"';
lbl11 = 'panel "Find states"';
lbl12 = 'visualization area';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_TpTest;

% GUI
h.menu_TP_allTest = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'tp','all',h_fig});

h.menu_TP_projectManagementArea = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_routineTest_Callback,'tp','project management area',h_fig});

h.menu_TP_sampleManagementTest = uimenu(h_men,'label',lbl2);
h = buildMenuSampleManagement(h);

h.menu_TP_plotTest = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_routineTest_Callback,'tp','plot',h_fig});

h.menu_TP_subImagesTest = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_routineTest_Callback,'tp','sub-images',h_fig});

h.menu_TP_backgroundTest = uimenu(h_men,'label',lbl5);
h = buildMenuBackground(h);

h.menu_TP_resampling = uimenu(h_men,'label',lbl6,'callback',...
    {@menu_routineTest_Callback,'tp','re-sampling',h_fig});

h.menu_TP_crossTalksTest = uimenu(h_men,'label',lbl7,'callback',...
    {@menu_routineTest_Callback,'tp','cross-talks',h_fig});

h.menu_TP_denoisingTest = uimenu(h_men,'label',lbl8,'callback',...
    {@menu_routineTest_Callback,'tp','denoising',h_fig});

h.menu_TP_photobleachingTest = uimenu(h_men,'label',lbl9,'callback',...
    {@menu_routineTest_Callback,'tp','photobleaching',h_fig});

h.menu_TP_factorCorrectionsTest = uimenu(h_men,'label',lbl10,'callback',...
    {@menu_routineTest_Callback,'tp','factor corrections',h_fig});

h.menu_TP_findStatesTest = uimenu(h_men,'label',lbl11,'callback',...
    {@menu_routineTest_Callback,'tp','find states',h_fig});

h.menu_TP_visualizationArea = uimenu(h_men,'label',lbl12,'callback',...
    {@menu_routineTest_Callback,'tp','visualization area',h_fig});

