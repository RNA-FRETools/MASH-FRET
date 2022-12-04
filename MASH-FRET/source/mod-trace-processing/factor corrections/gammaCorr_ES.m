function [p,ES,gamma,beta,ok,str] = gammaCorr_ES(i,p,prm,fact,h_fig)

proj = p.curr_proj;
p_proj = p.proj{proj};
gamma = NaN;
beta = NaN;
str = [];

if size(p_proj.S,1)==0
    ES = NaN;
    str = 'no stoichiometry available';
    ok = false;
    return
    
elseif isempty(p_proj.ES{i})
    disp('ES linear regression: calculate ES histograms...');
    
    % update all intensity corrections before re-building ES hist
    N = size(p.proj{proj}.TP.prm,2);
    for n = 1:N
        [p,opt] = resetMol(n, 'ttPr', p);
        p = plotSubImg(n, p, []);
        [p,~] = updateIntensities(opt, n, p, h_fig);
    end
    
    % build ES hist
    fact_i = fact;
    fact_i(:,i) = ones(2,1);
    [ES,ok,str] = getES(i,p_proj,prm,fact_i,h_fig);
    if ~ok
        return
    end
    if numel(ES)==1 && isnan(ES)
        ok = false;
        str = 'no stoichiometry available';
        return
    end
    
elseif numel(p_proj.ES{i})==1 && isnan(p_proj.ES{i})
    ES = p_proj.ES{i};
    str = 'no stoichiometry available';
    ok = false;
    return
    
else
    ES = p_proj.ES{i};
end

% calculate gamma
disp('ES linear regression: perform linear regression...');
[gamma,beta,ok] = ESlinreg(ES,prm(i,:));
if ~ok
    str = 'ES linear regression failed';
    return
end
disp('ES linear regression: process completed!');
