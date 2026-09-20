function ud_lstMolStr(p, h_lb)

str_lst = getStrList_TP_molecules(p.proj{p.curr_proj});

currMol = p.ttPr.curr_mol(p.curr_proj);

top = get(h_lb,'Listboxtop');
if top>numel(str_lst)
    top = numel(str_lst);
end
set(h_lb, 'String', str_lst, 'Value', currMol,'Listboxtop',top);
