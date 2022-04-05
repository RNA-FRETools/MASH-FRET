function routinetest_setExpSet_channels(h_fig0,p)
% routinetest_setExpSet_channels(h_fig0,p)
%
% Set tab "Channels" of experiment settings to proper values 
%
% h_fig0: handle to main figure
% p: structure containing default as set by getDefault_VP

h0 = guidata(h_fig0);
h_fig = h0.figure_setExpSet;
h = guidata(h_fig);

prm = p.es{p.nChan,p.nL}.chan;

% set number of channels
set(h.edit_nChan,'string',num2str(p.nChan));
edit_setExpSet_nChan(h.edit_nChan,[],h_fig,h_fig0);

% set emitter labels
h = guidata(h_fig);
for c = 1:p.nChan
    set(h.edit_chanLbl(c),'string',prm.emlbl{c});
    edit_setExpSet_chanLbl(h.edit_chanLbl(c),[],h_fig,c);
end


