function h = buildMenuKineticAnalysis(h)
% Creates sub-menus of "Standard kinetic analysis" menu in menubar.
%
% h = buildMenuKineticAnalysis(h);
%
% h: structure to update with handles to new UI components and that must contain fields:
%  h.menu_kineticAnalysis: handle to menu "Standard kinetic analysis"
%  h.figure_MASH: handle to main figure

% Last update by MH, 21.12.2020: remove useless step 4 (back-simulation)
% created by MH, 3.3.2020

% default
lbl0 = 'Import analysis file...';
lbl1 = 'All steps';
lbl2 = 'Step 1: Determine number of states';
lbl3 = 'Step 2: Determine FRET states & deviations';
lbl4 = 'Step 3: Determine transition rates';
% lbl5 = 'Step 4: Back-simulation';

% parents
h_fig = h.figure_MASH;
h_men = h.menu_kineticAnalysis;

% GUI
h.menu_kinAna_import = uimenu(h_men,'label',lbl0,'callback',...
    {@menu_kinAna_import_Callback,h_fig});

h.menu_kinAna_allSteps = uimenu(h_men,'label',lbl1,'callback',...
    {@menu_kinAna_Callback,0,h_fig});

h.menu_kinAna_step1 = uimenu(h_men,'label',lbl2,'callback',...
    {@menu_kinAna_Callback,1,h_fig});

h.menu_kinAna_step2 = uimenu(h_men,'label',lbl3,'callback',...
    {@menu_kinAna_Callback,2,h_fig});

h.menu_kinAna_step3 = uimenu(h_men,'label',lbl4,'callback',...
    {@menu_kinAna_Callback,3,h_fig});

% h.menu_kinAna_step4 = uimenu(h_men,'label',lbl5,'callback',...
%     {@menu_kinAna_Callback,4,h_fig});
