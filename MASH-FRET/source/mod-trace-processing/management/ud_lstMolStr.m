function ud_lstMolStr(p, h_lb)
currMol = 0;
str_lst = {};
if ~isempty(p.proj)
    proj = p.curr_proj;
    incl = p.proj{proj}.coord_incl;
    molTag = p.proj{proj}.molTag;
    nMol = size(incl,2);
    str_lst = cell(1,nMol);
    for m = 1:nMol
        if incl(m)
            str_lst{m} = num2str(m); 
            
            % color according to molecule tag; added by FS, 24.4.2018
            if molTag(m) > 1
                colorlist = {'transparent', '#4298B5', '#DD5F32', '#92B06A', '#ADC4CC', '#E19D29'};
                str_lst{m} = ['<html><body  bgcolor="' colorlist{molTag(m)} '">' ...
                '<font color="white">' num2str(m) '</font></body></html>'];
            end
            
        else
            str_lst{m} = ['<html><body  bgcolor="#232323">' ...
                '<font color="white">' num2str(m) '</font></body></html>'];
        end
    end
    currMol = p.curr_mol(proj);
end
top = get(h_lb,'Listboxtop');
set(h_lb, 'String', str_lst, 'Value', currMol);
if numel(str_lst)>=top
    set(h_lb,'Listboxtop',top);
else
    set(h_lb,'Listboxtop',1);
end