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
for l = 2:L
    if dat(l)~=dat(l0)
        if (l-l0)<=t_min
            if l0>1
                newval = dat(l0-1); % elongates previous state
            else
                newval = dat(l); % elongates next state
            end
            dat_db(l0:l-1) = newval;
        end
        l0 = l;
    end
end
