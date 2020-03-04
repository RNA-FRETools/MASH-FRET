function h = buildMenuKinsoftChallenge(h)
% Creates sub-menus of "Kinsoft challenge" menu in menubar.
%
% h = buildMenuKinsoftChallenge(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_kinsoftChallenge: handle to menu "Simulation test"
%  h.figure_MASH: handle to main figure

% created by MH, 3.3.2020

% default
lbl0 = 'All steps';
lbl1 = 'Step 1: Find states';
lbl2 = 'Step 2: Determine FRET states';
lbl3 = 'Step 3: Get transition rates';
lbl4 = 'Step 4: Back-simulation';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_kinsoftChallenge;

% GUI
h.menu_kinSoft_allSteps = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_kinSoft_Callback,0,h_fig});

h.menu_kinSoft_step1 = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_kinSoft_Callback,1,h_fig});

h.menu_kinSoft_step1 = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_kinSoft_Callback,2,h_fig});

h.menu_kinSoft_step1 = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_kinSoft_Callback,3,h_fig});

h.menu_kinSoft_step1 = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_kinSoft_Callback,4,h_fig});
