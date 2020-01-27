function [ok,prm] = checkKmeanStart(prm)

% initialize results
ok = 0;

% collect processing parameters
mu_0 = prm.clst_start{2}(:,1);
J_0 = prm.clst_start{1}(3);

% look for doubled
isdouble = 0;
for j=1:J_0
    ind = 1:J_0;
    ind(ind==j)=[];
    if sum(mu_0(j)==mu_0(ind))
        isdouble = 1;
        break
    end
end

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
