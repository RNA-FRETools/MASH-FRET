function expr = replaceByArrays(expr,K,chanExc,exc)

expr = strrep(expr,'*','.*');
expr = strrep(expr,'/','./');

for i = 1:K
    for j = 1:K
        l = find(exc==chanExc(j));
        expr = strrep(expr,sprintf('I_%i%i',i,j),...
            sprintf('I(:,%i,%i)',i,l));
        expr = strrep(expr,sprintf('E_%i%i',i,j),...
            sprintf('E(:,%i,%i)',i,j));
        expr = strrep(expr,sprintf('gamma_%i%i',i,j),...
            sprintf('gamma(:,%i,%i)',i,j));
        expr = strrep(expr,sprintf('beta_%i%i',i,j),...
            sprintf('beta(:,%i,%i)',i,j));
    end
end