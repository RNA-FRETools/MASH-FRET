function str_lst = getStrList_TP_molecules_post_2025a(proj)

incl = proj.coord_incl;
molTag = proj.molTag;
tagNames = proj.molTagNames;

N = size(incl,2);
str_lst = cell(1,N);

for m = 1:N
    if incl(m)
        str_lst{m} = num2str(m); 
        if any(molTag(m,:))
            str_tag = join(tagNames(molTag(m,:)));
            str_tag = [' ', str_tag{1}];
        else
            str_tag = '';
        end
        str_lst{m} = [num2str(m) str_tag];

    else
        str_lst{m} = [num2str(m) ' xxxxxxxxxx'];
    end
end
