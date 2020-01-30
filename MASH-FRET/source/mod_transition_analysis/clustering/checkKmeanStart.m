function [ok,prm] = checkKmeanStart(prm)

% initialize results
ok = 0;

% collect processing parameters
mu = prm.clst_start{2}(:,[1,2]);
J = prm.clst_start{1}(3);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);

% look for doubled
nTrs = getClusterNb(J,mat,clstDiag);
isdouble = size(mu,1)~=nTrs;

% ask user for modification fo doubled
if isdouble
    question = sprintf(cat(2,'Some states have identical values ',...
        'in the starting guess. Do you want to use default state ',...
        'values?'));
    choice = questdlg(question, 'Starting guess is ill-defined', ...
        'Yes, use default', 'Cancel, I will correct manually', ...
        'Yes, use default');
    if ~strcmp(choice, 'Yes, use default')
        return
    end
    % use default starting guess
    prm = setDefKmean(prm);
end

ok = 1;
