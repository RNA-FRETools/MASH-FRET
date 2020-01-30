function nTrs = getClusterNb(J,mat,clstDiag)
% Calculate the number of clusters from the number of states and clustering settings

if mat
    if clstDiag
        nTrs = J^2;
    else
        nTrs = J*(J-1);
    end
else
    nTrs = J;
end