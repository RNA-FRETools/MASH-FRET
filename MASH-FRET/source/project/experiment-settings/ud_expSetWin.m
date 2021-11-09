function ud_expSetWin(h_fig)
% ud_expSetWin(h_fig)
% 
% Set properties of controls in window "Experimental settings" to proper 
% values
%
% h_fig: handle to "Experiment settings" figure

ud_setExpSet_tabImp(h_fig);
ud_setExpSet_tabChan(h_fig);
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);