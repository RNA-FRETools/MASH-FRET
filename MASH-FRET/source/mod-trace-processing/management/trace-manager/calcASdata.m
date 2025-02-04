function ASdata = calcASdata(molid,traj,seq,dt,lt)

id = getASdataindex;
id(1) = [];

% initialize output
ASdata = cell(1,numel(id));

% trajectories
ASdata{id(1)} = [seq,repmat(molid,size(seq,1),1)]; % state trajectories

% mean, max, min, median and SNR
ASdata{id(2)} = mean(traj); % mean intensity
ASdata{id(3)} = min(traj); % minimum intensity
ASdata{id(4)} = max(traj); % maximum intensity
ASdata{id(5)} = median(traj); % median intensity
ASdata{id(6)} = mean(traj)/std(traj); % snr

% states
ASdata{id(7)} = numel(unique(seq)); % number of states
ASdata{id(8)} = size(dt,1); % number of transitions
ASdata{id(9)} = mean(dt(:,1)); % mean state dwell time

% dwell times
nTrs = size(dt,1);
ASdata{id(10)} = [dt(:,2),repmat(molid,nTrs,1)]; % state values
ASdata{id(11)} = [dt(:,1),repmat(molid,nTrs,1)]; % state dwell times
ASdata{id(12)} = [lt(:,1),repmat(molid,nTrs,1)]; % state lifetimes