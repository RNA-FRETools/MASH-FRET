function routinetest_setExpSet_lasers(h_fig0,p)
% routinetest_setExpSet_lasers(h_fig0,p)
%
% Set tab "Lasers" of experiment settings to proper values 
%
% h_fig0: handle to main figure
% p: structure containing default as set by getDefault_VP

h0 = guidata(h_fig0);
h_fig = h0.figure_setExpSet;
h = guidata(h_fig);

prm = p.es{p.nChan,p.nL}.las;

% set number of lasers
set(h.edit_nExc,'string',prm.nlas);
edit_setExpSet_nExc(h.edit_nExc,[],h_fig,h_fig0);

h = guidata(h_fig);
for l = 1:prm.nlas
    % set laser wavelengths
    set(h.edit_excWl(l),'string',num2str(prm.laswl(l)));
    edit_setExpSet_excWl(h.edit_excWl(l),[],h_fig,l);
    
    % set specific emitter
    set(h.popup_excEm(l),'value',prm.lasem(l)+1);
    popup_setExpSet_excEm(h.popup_excEm(l),[],h_fig,l);
end


