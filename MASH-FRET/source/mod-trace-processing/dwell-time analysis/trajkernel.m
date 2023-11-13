function filtertraj = trajkernel(traj,incl,kernel)
% filtertraj = trajkernel(traj,incl,kernel)
%
% Applies kernel to trajectory.
%
% traj: L-length vector containing data to filter
% incl: L-length logical vector with to include/exclude (1/0) traj data 
%       points from state calculation in filtertraj.
% kernel: L-length vector containg filter's kernel
% filtertraj = L-length vector containing filtered data

stateVals = unique(kernel);
filtertraj = zeros(size(traj));
for val = stateVals
    filtertraj(kernel==val) = mean(traj(incl & kernel==val));
end