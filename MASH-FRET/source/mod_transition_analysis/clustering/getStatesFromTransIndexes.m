function [j1_vect,j2_vect] = getStatesFromTransIndexes(curr_k,J,mat,clstDiag)
% Recover state indexes from cluster index(es)

nK = size(curr_k,2);
j1_vect = zeros(1,nK);
j2_vect = zeros(1,nK);

if mat
    k = 0;
    for j1 = 1:J
        for j2 = 1:J
            if j1==j2 && ~clstDiag
                continue
            end
            k = k+1;
            for k_i = 1:nK
                if k==curr_k(k_i)
                    j1_vect(k_i) = j1;
                    j2_vect(k_i) = j2;
                end
            end
        end
    end
else
    j1_vect = 2*(curr_k-1)+1;
    j2_vect = 2*curr_k;
end