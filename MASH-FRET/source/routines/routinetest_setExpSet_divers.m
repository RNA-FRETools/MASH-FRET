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

if ~isfield(p.es{p.nChan,p.nL},'div')
    return
end

prm = p.es{p.nChan,p.nL}.div;

% set project title
if isfield(prm,'projttl')
    set(h.edit_projName,'string',prm.projttl);
    edit_setExpSet_projName(h.edit_projName,[],h_fig);
end

% set molecule name
if isfield(prm,'molname')
    set(h.edit_molName,'string',prm.molname);
    edit_setExpSet_molName(h.edit_molName,[],h_fig);
end

% set experimental conditions
if isfield(prm,'expcond')
    tbldat = h.table_cond.Data;
    evd = [];
    tbldat(3:end,:) = repmat({''},size(tbldat,1)-2,3);
    for r = 3:(3+size(prm.expcond,1)-1)
        for c = 1:3
            tbldat{r,c} = prm.expcond{r-3+1,c};
            set(h.table_cond,'Data',tbldat);
            evd.Indices = [r,c];
            table_setExpSet_cond(h.table_cond,evd,h_fig);
        end
    end
end

% set sampling time
if isfield(prm,'splt') && strcmp(h.edit_splTime.Enable,'on')
    set(h.edit_splTime,'string',num2str(prm.splt));
    edit_setExpSet_splTime(h.edit_splTime,[],h_fig);
end

% set plot colors
if isfield(prm,'plotclr')
    for chan = 1:size(prm.plotclr,1)
        set(h.popup_chanClr,'value',chan);
        popup_setExpSet_chanClr(h.popup_chanClr,[],h_fig);
        push_setExpSet_clr([],prm.plotclr(chan,:),h_fig);
    end
else
    push_setExpSet_defclr([],[],h_fig);
end

