function cmb = getCombinations(js,vs)

cmb = [];
for v = 1:numel(vs)
    if v>1
        cmb_add = [];
        for j = 1:numel(js)
            cmb_add = cat(1,cmb_add,cat(2,cmb,repmat(js(j),size(cmb,1),1)));
        end
        cmb = cmb_add;
    else
        cmb = js';
    end
end