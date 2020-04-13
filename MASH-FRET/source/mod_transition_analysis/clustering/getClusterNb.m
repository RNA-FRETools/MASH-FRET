function nTrs = getClusterNb(J,mat,clstDiag)
% Calculate the number of clusters from the number of states and clustering settings

if mat==1
    if clstDiag
        nTrs = J^2;
    else
        nTrs = J*(J-1);
    end
elseif mat==2
    nTrs = 2*J;
else
    nTrs = J;
end