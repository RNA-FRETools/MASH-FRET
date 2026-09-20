function str_lst = getStrList_TP_molecules(proj)

if isMATLABReleaseOlderThan('R2025a')
    str_lst = getStrList_TP_molecules_pre_2025a(proj);
else
    str_lst = getStrList_TP_molecules_post_2025a(proj);
end

