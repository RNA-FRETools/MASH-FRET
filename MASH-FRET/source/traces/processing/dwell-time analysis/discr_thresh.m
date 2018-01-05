
function discrTrace = discr_thresh(trace, discrVal, low, up, nbStates)
% Return the FRET-steps determined from the input FRET-time trace. Steps
% are determined by a thresholding method: step values and their low and
% high threshold values are fixed by user.

rev = 0;
if size(trace,2) > size(trace,1)
    trace = trace';
    rev = 1;
end

nbFrames = length(trace);

discrVal = discrVal(1:nbStates);
low = low(1:nbStates);
up = up(1:nbStates);
low(nbStates) = -Inf;
up(1) = Inf;

[r,c,v] = find(low < trace(1,1));
if ~isempty(c)
    curr_state = c(1,1);
else
    curr_state = numel(low);
end
discrTrace(1,1) = discrVal(curr_state);
         
for i = 2:nbFrames
    if trace(i,1) >= up(curr_state)
        [r,c,v] = find(low < trace(i,1));
        curr_state = c(1,1);
    elseif trace(i,1) <= low(curr_state)
        [r,c,v] = find(up > trace(i,1));
        curr_state = c(1,size(c,2));
    end
    discrTrace(i,1) = discrVal(curr_state);
end            

if rev
    discrTrace = discrTrace';
end

  