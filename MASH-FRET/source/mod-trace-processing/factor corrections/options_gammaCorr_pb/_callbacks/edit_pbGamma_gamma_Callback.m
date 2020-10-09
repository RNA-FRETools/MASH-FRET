function edit_pbGamma_gamma_Callback(obj, ~, h_fig2)

q = guidata(h_fig2);
set(obj,' String', num2str(q.prm{1}));


% cancelled by MH, 15.1.2020
% % show or hide the pb cutoff
% function checkbox_showCutoff(obj, ~, h_fig, h_fig2)
% 
% q = guidata(h_fig2);
% q.prm{2}(1) = get(obj, 'Value');
% guidata(h_fig2,q);
% 
% ud_pbGamma(h_fig,h_fig2)


