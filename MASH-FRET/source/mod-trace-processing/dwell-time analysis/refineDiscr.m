function tr = refineDiscr(aveCycle, tr, tr_raw)
if aveCycle > 0
    
    rev = 0;
    if size(tr_raw,2) > size(tr_raw,1)
        rev = 1;
        tr_raw = tr_raw';
        tr = tr';
    end
    
    for n = 1:aveCycle
        tr = averageSteps(tr, tr_raw);
    end
    
    if rev
        tr = tr';
    end
end


function fretSteps = averageSteps(fretSteps, fretTrace)

nbFrames = size(fretSteps,1);

% Get FRET steps value and sort them: highest value in first position.
fret_state(1) = fretSteps(1,1);
for ii = 1:nbFrames
    ok = true;
    % Tcheck if FRET value is not already stored
    for jj = 1:size(fret_state,2)
        if fretSteps(ii,1) == fret_state(jj)
            ok = false;
        end
    end
    if ok
        fret_state(size(fret_state,2) + 1) = fretSteps(ii,1);
    end
end
fret_state = sort(fret_state, 2, 'descend');

% number of FRET steps values detected in trace
N = size(fret_state, 2);

fretSteps_unAve = fretSteps;
j = 1;
noStep = 1;

for i = 1:nbFrames - 1
    if fretSteps_unAve((i+1),1) ~= fretSteps_unAve(i,1)
        noStep = 0;
        changPnt(j,1) = i;
        j = j + 1;
    end
end
    
if noStep
    fretSteps_ave = mean(fretTrace(:,1));
    for j = 1:N
        deltaVal(j) = abs(fretSteps_ave - fret_state(j));
    end
    [o, indexes] = sort(deltaVal, 'ascend');
    fretSteps(:,1) = fret_state(indexes(1,1));
        
else
    for i = 1:size(changPnt,1)
        if i == 1
            interV(1) = 1;
            interV(2) = changPnt(i,1);
        elseif i == size(changPnt,1)
            interV(1) = changPnt(i,1);
            interV(2) = nbFrames;
        else
            interV(1) = changPnt(i,1);
            interV(2) = changPnt((i+1),1);
        end
        fretSteps_ave = mean(fretTrace(interV(1):interV(2), 1));
        for j = 1:N
            deltaVal(j) = abs(fretSteps_ave - fret_state(j));
        end
        [o, indexes] = sort(deltaVal, 'ascend');
        fretSteps(interV(1):interV(2), 1) = fret_state(indexes(1,1));
    end
end