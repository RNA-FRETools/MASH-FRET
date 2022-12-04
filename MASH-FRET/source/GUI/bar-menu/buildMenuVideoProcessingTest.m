function h = buildMenuVideoProcessingTest(h)
% Creates sub-menus of "Video processing test" menu in menubar.
%
% h = buildMenuVideoProcessingTest(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_VpTest: handle to menu "Video processing test"

% created by MH, 07.02.2020

% default
lbl0 = 'All panels';
lbl1 = 'visualization area';
lbl2 = 'panel "Plot"';
lbl3 = 'panel "Experimental settings"';
lbl4 = 'panel "Edit and export video"';
lbl5 = 'panel "Molecule coordinates"';
lbl6 = 'panel "Intensity integration"';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_VpTest;

% GUI
h.menu_VP_allTest = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_routineTest_Callback,'vp','all',h_fig});

h.menu_VP_visualizationAreaTest = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_routineTest_Callback,'vp','visualization area',h_fig});

h.menu_VP_plotTest = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_routineTest_Callback,'vp','plot',h_fig});

h.menu_VP_experimentSettingsTest = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_routineTest_Callback,'vp','experiment settings',h_fig});

h.menu_VP_editVideoTest = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_routineTest_Callback,'vp','edit and export video',h_fig});

h.menu_VP_moleculeCoordinatesTest = uimenu(h_men,'label',lbl5,'callback',...
    {@menu_routineTest_Callback,'vp','molecule coordinates',h_fig});

h.menu_VP_intensityIntegrationTest = uimenu(h_men,'label',lbl6,'callback',...
    {@menu_routineTest_Callback,'vp','intensity integration',h_fig});
