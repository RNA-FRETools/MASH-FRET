function dat_db = deblurrSeq(dat)
% dat = deblurrSeq(dat)
%
% Delete states that dwell less or equal to a certain number of data points (default:1) from the input sequence. The duration of the previous state in the sequence (if any) is prolongated by this number data point. If the previous state is not acessible, the duration of the next state in the sequence is prolongated.

% created by MH, 7.1.2020

% initializes returned data
dat_db = dat;

% default
t_min = 1;

L = numel(dat);
l0 = 1;
for l = 2:L-1
    if dat_db(l)~=dat_db(l0)
        if l0==1 % skip first plateau
            l0 = l;
            continue
        end
        if (l-l0)<=t_min
            state0 = dat_db(l-t_min-1);
            state1 = dat_db(l-1);
            state2 = dat_db(l);
            if (state0<state1 && state1<state2) || ...
                    (state0>state1 && state1>state2)
                newval = dat_db(l0-1); % elongates previous state
                dat_db(l0:l-1) = newval;
            end
        end
        l0 = l;
    end
end
