function saveStatesResults(param,fname)
% positive success (TP): success rejecting null hypothesis (found J0 states)
% positive error (FP): error by rejecting null hypothesis (found J0 states)
% negative error (FN): error by not rejecting null hypothesis (found J~=J0 states)

pname = 'C:\Users\Mélodie\Documents\MATLAB\data\MASH PAPER\';
tol = 0.05;
states0 = [0.3 0.45 0.6 0.8];

if ~exist(pname,'dir')
    pname = 'D:\analysis\MASHsmFRET_test\publication\';
    if ~exist(pname,'dir')
        fprintf(cat(2,'\nCould not find folder:\n\t',pname,'\n'));
        return;
    end
end

TP = 0;
TN = 0;
FP = 0;
FN = 0;

S = size(param,2);
K0 = size(states0,2);

for s = 1:S
    mus = param{s}{1};
    K = size(mus,2);
    if K==K0
        diffstate = abs(repmat(mus,K0,1) - repmat(states0',1,K));
        [diffstate,id] = min(diffstate,[],1);
        match = double(diffstate<tol);
        if sum(match)==K0 && numel(unique(id))==K0
            TP = TP + 1;
        else
            FP = FP + 1;
        end
    else
        FN = FN+1;
    end
end

recall = TP/(TP+FN);
precision = TP/(TP+FP);
accuracy = (TP-TN)/(TP+TN+FP+FN);

f = fopen(cat(2,pname,fname),'Wt');
fprintf(f,'TP\tFP\tFN\tTN\taccuracy\trecall\tprecision\n');
fprintf(f,cat(2,repmat('%d\t',1,7),'\n'),[TP,FP,FN,TN,accuracy,recall,precision]');
fclose(f);

