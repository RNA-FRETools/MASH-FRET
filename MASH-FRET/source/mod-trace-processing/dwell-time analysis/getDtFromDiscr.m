function dt = getDtFromDiscr(discr, rate)

% Get states for each transition and dwell-times
dt = [];
i_prev = 1;
for i = 2:size(discr,1)
    if discr(i,1) ~= discr((i-1), 1)
        % 1st column = duration of previous state
        dt((size(dt,1)+1),1) = i - i_prev;
        i_prev = i;
        % 2nd column = previous state value
        dt(size(dt,1),2) = discr((i-1), 1);
        % 3rd column = next state value
        dt(size(dt,1),3) = discr(i,1); 
    end
    if i == size(discr,1)
        % 1st column = duration of last state
        dt((size(dt,1)+1),1) =  i - i_prev + 1;
        % 2nd column = previous state value
        dt(size(dt,1),2) = discr(size(discr,1), 1);
        % 3rd column = unknown next state value
        dt(size(dt,1),3) = NaN;
    end
end
if isempty(dt)
    dt = [rate discr(1) NaN];
else
    dt(:,1) = dt(:,1)*rate;
end


