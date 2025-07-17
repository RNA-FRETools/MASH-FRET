function str = maxlengthstr(cellarr)
strlen = cellfun(@length,cellarr);
id = find(strlen==max(strlen),1);
str = cellarr{id};