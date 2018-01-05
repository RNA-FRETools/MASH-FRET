function dt = getDtFromMix(mix,J_val)

L = size(mix,2); % no. of time step
J = size(mix,1); % no. of states

[j,o,o] = find(mix(:,l));
if numel(j)>1
    j_prev = j;
else
    while l<=L
        while l<=L && mix(j,l)~=0
            l = l+mix(j,l);
        end
        dt = [dt; [l j j_next]];
        l = 0;
    end
end