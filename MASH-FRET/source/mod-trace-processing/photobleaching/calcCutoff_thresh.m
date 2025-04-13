function [incl,cutOff] = calcCutoff_thresh(trace,minofft,start,thresh,...
    extra,mincut,mol)

% determine last valid data
lastN = find(all(~isnan(trace),[3,2]),1,'last');

% discretize trajectories
L = size(trace,1);
frames = (start:L)';
trace = trace(frames,:);
[Ltrunc,ntraj] = size(trace);
if ntraj>1
    strtraj = 'trajectories';
else
    strtraj = 'trajectory';
end
fprintf(['Cutoff detection: discretize ',strtraj,' of molecule %i...\n'],...
    mol);
trace = discrtrace4pbdetect(trace');

% normalize discretized trajectories by maximum value
trace = trace./repmat(max(trace,[],2),1,Ltrunc);

% detect off state
incl = true(L,ntraj);
for n = 1:ntraj
    incl(frames(trace(n,:)<thresh(n)),n) = false;
end

% find photobleaching cutoff
prc = cumsum(double(trace<repmat(thresh,1,Ltrunc)),2,'reverse')./...
    repmat((Ltrunc:-1:1),[ntraj,1]);
cutOff = repmat(lastN,1,ntraj);
for n = 1:ntraj
    cutOff_n = find(prc(n,:)>=0.99,1,'first')+start-1-extra(n);
    if ~isempty(cutOff_n) && cutOff_n<lastN && cutOff_n>=mincut(n) && ...
            (lastN-cutOff_n)>=minofft(n)
        cutOff(n) = cutOff_n;
    end
end


function trace = discrtrace4pbdetect(trace)
prm(1) = 1;
prm(2) = 5;
prm(3) = 5;
prm([7,6,5]) = [0,0,0];
prm = repmat(prm,size(trace,2),1);
trace = getDiscr(2,trace,~isnan(trace),prm,[],false,0,[]);
