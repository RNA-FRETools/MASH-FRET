function ud_lstMolStr(p, h_lb)
currMol = 0;
str_lst = {};
if ~isempty(p.proj)
    proj = p.curr_proj;
    incl = p.proj{proj}.coord_incl;
    nMol = size(incl,2);
    str_lst = cell(1,nMol);
    for m = 1:nMol
        if incl(m)
            str_lst{m} = num2str(m);
        else
            str_lst{m} = ['<html><body  bgcolor="#232323">' ...
                '<font color="white">' num2str(m) '</font></body></html>'];
        end
    end
    currMol = p.curr_mol(proj);
end
set(h_lb, 'String', str_lst, 'Value', currMol);