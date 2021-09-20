function dtHist = updateDtHist(prm,mols,v1,varargin)

% get reference histogram
J = prm.lft_start{2}(1);
bin = prm.lft_start{2}(3);
excl = prm.lft_start{2}(4);
rearr = prm.lft_start{2}(5);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
clst = prm.clst_res{1}.clusters{J};
wght = prm.lft_start{1}{v1,1}(8);

v2 = 0;
if ~isempty(varargin)
    v2 = varargin{1};
end

% bin state values
nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
[vals,js] = binStateValues(prm.clst_res{1}.mu{J},bin,[j1,j2]);
V = numel(vals);
clst_new = clst;
for val = 1:V
    for j = 1:numel(js{val})
        clst_new(clst(:,end-1)==js{val}(j),end-1) = val;
        clst_new(clst(:,end)==js{val}(j),end) = val;
    end
end
clst = clst_new;

% re-arrange state sequences by cancelling transitions belonging to diagonal clusters
if rearr
    [ms,o,o] = unique(clst(:,4));
    dat_new = [];
    for m = ms'
        dat_m = clst(clst(:,4)==m,:);
        if isempty(dat_m)
            continue
        end
        dat_m = adjustDt(dat_m);
        if size(dat_m,1)==1
            continue
        end
        dat_new = cat(1,dat_new,dat_m);
    end
    clst = dat_new;
end

% build histogram
dtHist = getDtHist(clst,v1,v2,mols,excl,wght);

