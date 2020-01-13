function [ES,gamma,beta,ok,str] = gammaCorr_ES(p_proj,prm,h_fig)

nFRET = size(p_proj.FRET,1);
gamma = NaN(1,nFRET);
beta = NaN(1,nFRET);
ok = true;
str = [];
    
if sum(cellfun('isempty',p_proj.ES))
    disp('ES linear regression: calculate ES histograms...');
    [ES,ok,str] = getES(p_proj,prm,[],h_fig);
    if ~ok
        return
    end
else
    ES = p_proj.ES;
end

% calculate gamma
disp('ES linear regression: perform linear regression...');
for i = 1:nFRET
    [gamma(i),beta(i),ok] = ESlinreg(ES{i},prm(i,:));
    if ~ok
        str = 'ES linear regression failed';
        break
    end
end
disp('ES linear regression: process completed!');
