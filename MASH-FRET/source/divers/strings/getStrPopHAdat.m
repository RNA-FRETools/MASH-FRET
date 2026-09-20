function str = getStrPopHAdat(proj)

if isMATLABReleaseOlderThan('R2025a')
    str = getStrPopHAdat_pre_2025a(proj);
else
    str = getStrPopHAdat_post_2025a(proj);
end
