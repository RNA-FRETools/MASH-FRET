function routinetest_setExpSet_divers(h_fig0,p)
% routinetest_setExpSet_divers(h_fig0,p)
%
% Set tab "Divers" in experiment settings to proper values 
%
% h_fig0: handle to main figure
% p: structure containing default as set by getDefault_VP

h0 = guidata(h_fig0);
h_fig = h0.figure_setExpSet;
h = guidata(h_fig);

prm = p.es{p.nChan,p.nL}.div;

% set project title
set(h.edit_projName,'string',prm.projttl);
edit_setExpSet_projName(h.edit_projName,[],h_fig);

% set molecule name
set(h.edit_molName,'string',prm.molname);
edit_setExpSet_molName(h.edit_molName,[],h_fig);

% set experimental conditions
tbldat = h.table_cond.Data;
evd = [];
for r = 3:(3+size(prm.expcond,1)-1)
    for c = 1:3
        tbldat{r,c} = prm.expcond{r-3+1,c};
        set(h.table_cond,'Data',tbldat);
        evd.Indices = [r,c];
        table_setExpSet_cond(h.table_cond,evd,h_fig);
    end
end

% set sampling time
if strcmp(h.edit_splTime.Enable,'on')
    set(h.edit_splTime,'string',num2str(prm.splt));
    edit_setExpSet_splTime(h.edit_splTime,[],h_fig);
end

% set plot colors
for chan = 1:size(prm.plotclr,1)
    set(h.popup_chanClr,'value',chan);
    popup_setExpSet_chanClr(h.popup_chanClr,[],h_fig);
    push_setExpSet_clr(prm.plotclr(chan,:),[],h_fig);
end

