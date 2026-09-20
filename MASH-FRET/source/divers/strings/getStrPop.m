function str_pop = getStrPop(menu, param)

if isMATLABReleaseOlderThan('R2025a')
    str_pop = getStrPop_pre_2025a(menu, param);
else
    str_pop = getStrPop_post_2025a(menu, param);
end
