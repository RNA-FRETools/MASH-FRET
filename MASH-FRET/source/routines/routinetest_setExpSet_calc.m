function routinetest_setExpSet_calc(h_fig0,p)
% routinetest_setExpSet_calc(h_fig0,p)
%
% Set tab "Calculations" of experiment settings to proper values 
%
% h_fig0: handle to main figure
% p: structure containing default as set by getDefault_VP

h0 = guidata(h_fig0);
h_fig = h0.figure_setExpSet;
h = guidata(h_fig);

prm = p.es{p.nChan,p.nL}.calc;

% empty FRET list
nPair = numel(h.list_FRET.String);
for pair = nPair:-1:1
    set(h.list_FRET,'value',pair);
    push_setExpSet_remFRET(h.push_remFRET,[],h_fig);
end

% add FRET pairs
nPair = size(prm.fret,1);
for pair = 1:nPair
    set(h.popup_don,'value',prm.fret(pair,1));
    set(h.popup_acc,'value',prm.fret(pair,2));
    push_setExpSet_addFRET(h.push_addFRET,[],h_fig);
end

% empty stoichiometry list
nPair = numel(h.list_S.String);
for pair = nPair:-1:1
    set(h.list_S,'value',pair);
    push_setExpSet_remS(h.push_remS,[],h_fig);
end

% add stoichiometry pairs
nPair = size(prm.s,1);
for pair = 1:nPair
    fret = find(prm.fret(:,1)==prm.s(pair,1) && ...
        prm.fret(:,2)==prm.s(pair,2));
    set(h.popup_S,'value',fret);
    push_setExpSet_addS(h.push_addS,[],h_fig);
end

