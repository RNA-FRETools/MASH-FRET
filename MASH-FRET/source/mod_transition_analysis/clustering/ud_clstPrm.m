function [curr,colList] = ud_clstPrm(curr,colList,nClrRef)

meth = curr.clst_start{1}(1);

% adjust model size
if curr.clst_start{1}(4)==1 && curr.clst_start{1}(3)<2
    curr.clst_start{1}(3) = 2;
end

% adjust cluster shape
if meth~=2 % k-mean or manual
    if curr.clst_start{1}(2)>3
        curr.clst_start{1}(2) = 3;
    end
end

% adjust TDP bootstrapping
if meth==3
    curr.clst_start{1}(6) = false;
end

% adjust diagonal clusters
if curr.clst_start{1}(4)~=1
    curr.clst_start{1}(9) = false; % no diagonal clusters
end

% get adjusted parameters
J = curr.clst_start{1}(3);
mat = curr.clst_start{1}(4);
clstDiag = curr.clst_start{1}(9);

% get number of clusters
nTrs = getClusterNb(J,mat,clstDiag);
nTrs_prev = size(curr.clst_start{2},1);

% update colour list
nClr = size(colList,1);
if nClr < nTrs
    colList(nClr+1:nTrs,:) = round(rand(nTrs-nClr,3)*100)/100;
end

% adjust starting guess size
for k = 1:nTrs
    if nTrs_prev<k
        curr.clst_start{2}(k,:) = curr.clst_start{2}(k-1,:);
    end
end
curr.clst_start{2} = curr.clst_start{2}(1:nTrs,:);

% update cluster colors
for k = 1:nTrs
    if nTrs_prev<k 
        curr.clst_start{3}(k,:) = colList(k,:);
    end
end
curr.clst_start{3} = curr.clst_start{3}(1:nTrs,:);

% re-arrange starting guess
if mat==1 % matrix
    states = [curr.clst_start{2}(1,1);curr.clst_start{2}(1:J-1,2)];
    rad = [curr.clst_start{2}(1,3);curr.clst_start{2}(1:J-1,4)];
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
    curr.clst_start{2} = [states(j1),states(j2),rad(j1),rad(j2)];
    
elseif mat==2 % symmetrical
    curr.clst_start{2} = [curr.clst_start{2}(1:J,:);...
        curr.clst_start{2}(1:J,[2,1,4,3])];
end

