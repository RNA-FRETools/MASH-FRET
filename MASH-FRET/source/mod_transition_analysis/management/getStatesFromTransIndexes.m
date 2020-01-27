function [j1,j2] = getStatesFromTransIndexes(curr_k,J)

k = 0;
for j1 = 1:J
    for j2 = 1:J
        if j1~=j2
            k = k + 1;
        end
        if k==curr_k
            break
        end
    end
    if k==curr_k
        break
    end
end