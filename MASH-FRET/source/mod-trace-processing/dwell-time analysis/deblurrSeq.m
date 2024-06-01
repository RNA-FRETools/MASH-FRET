function dat_db = deblurrSeq(dat)
% dat = deblurrSeq(dat)
%
% Delete states that dwell for one data points from the input sequence. 
% The duration of the previous state in the sequence (if any) is 
% prolongated by this number data point. If the previous state is not 
% acessible, the duration of the next state in the sequence is prolongated.

% created by MH, 7.1.2020

% initializes returned data
dat_db = dat;

L = numel(dat);
l0 = 1;
for l = 2:L-1
    if dat_db(l)~=dat_db(l0)
        if l0==1 % skip first dwell
            l0 = l;
            continue
        end
        if (l-l0)==1
            dat_db(l0) = dat_db(l0-1);
        end
        l0 = l;
    end
end
