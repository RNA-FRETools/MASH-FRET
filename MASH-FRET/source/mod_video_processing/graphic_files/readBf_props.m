function props = readBf_props(fullFname)
% props = readBf_props(fullFname)

bfdat = bfopen(fullFname);
    
% get metadata
metdat = split(char(bfdat{1,2}),',');
M = size(metdat,1);
props = {};
for m = 1:M
    metdat{m,1} = metdat{m,1}(2:end); % remove trailin space and opening brace
    metdat{m,1} = replace(metdat{m,1},' = ',' '); % replace "=" in properties' values by spaces
    if m==M
        metdat{m,1} = metdat{m,1}(1:end-1); % remove closing brace
    end
    md = split(metdat{m,1},'=');
    if size(md,1)>1
        props = cat(1,props,{md{1,1},bfdat{1,2}.get(md{1,1})});
    end
end
[~,id] = sort(props(:,1));
props = props(id',:);