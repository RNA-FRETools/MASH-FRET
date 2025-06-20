function [mix,seq,dt] = genstateseq(L,k,J,w,ip,tau)

% generate dwell times
notrans = ~any(k>0,[1,2]);
if J==1 || notrans
    if J>1
        if nnz(sum(k,1)>0)~=J || nnz(sum(k,2)>0)~=J
            % MH 19.12.2019: identify zero sums in rate matrix
            setContPan(cat(2,'Simulation aborted: when no transition ',...
                'is defined (null rates), initial state probabilities',...
                ' must be pre-defined.'),'error',h_fig);
            mix = [];
            seq = [];
            return
        end
        
        % pick a "first state" randomly
        state1 = randsample(1:J, 1, true, sum(ip));
    else
        state1 = 1;
    end
    
    mix = zeros(J,L);
    mix(state1,:) = 1;
    dt = [L state1 NaN];
    seq = state1*ones(L,1);

else
    stes = zeros(J,L);
    dt = [];
    state1 = randsample(1:J, 1, true, ip); % pick a first state
    l = 0;
    while l<L
        curr_l = ceil(l);
        if curr_l==0
            curr_l = 1;
        elseif curr_l>L
            curr_l = L;
        elseif sum(stes(:,curr_l),1)==1
            curr_l = curr_l+1;
        end
        
        % pick a first state
        if sum(w(state1,:))==0
            state2 = state1;
        else
            state2 = randsample(1:J, 1, true, w(state1,:)); % pick a next state
        end
        
        % dwell in numer of time bins
        if isinf(tau(state1)) % kinetic trap
            dl = L-l;
        else
            dl = random('exp',tau(state1));
        end
        
        % truncate dwell if larger than remaining time
        if (l+dl)>L
            dl = L-l;
        end
        
        dt = cat(1,dt,[dl state1 state2]);

        if l>0 && sum(stes(:,curr_l),1)<=1
            
            % the cumulation of the dt generated overflows or 
            % reaches the integration time limit
            if dl>=(1-sum(stes(:,curr_l),1))
                dl = dl - (1 - sum(stes(:,curr_l),1));
                l = l + (1 - sum(stes(:,curr_l),1));
                stes(state1,curr_l) = stes(state1,curr_l) + 1 - ...
                    sum(stes(:,curr_l),1);
                curr_l = curr_l + 1;
            
            % the cumulation of the dt generated does not reach the
            % integration time limit
            else
                stes(state1,curr_l) = stes(state1,curr_l) + dl;
                l = l + dl;
                state1 = state2;
                continue
            end
        end

        addl = fix(dl);
        if dl>0
            stes(state1,(curr_l):(curr_l+addl-1)) = 1;
        end
        
        fract_end = dl-addl;
        % the cumulation of the dt generated overflows the 
        % integration time limit
        if fract_end>0
            stes(state1,curr_l+addl) = fract_end;
        end
        
        l = l + fract_end + addl;
        state1 = state2;
        if size(stes,2)>L
            stes = stes(:,1:L);
        end
    end
    mix = stes./repmat(sum(stes,1),[J,1]);
    [~,max_ste] = max(stes,[],1);
    seq = max_ste';
end
