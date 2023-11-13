function statetraj = postprocessdiscrtraj(statetraj,prm,traj)
% statetraj = postprocessdiscrtraj(statetraj,prm,traj)
%
% Applies a series of post-processing to discretized trajectory, including:
% 1) ignoring one-point dwell times
% 2) binning states close in value
% 3) state reassignment
% 4) state recalculation
%
% statetraj: L-length vector containing discretized trajectory
% prm: [1-by-4] post-processing parameters
% traj: L-length vector containing non-discretized trajectory

if prm(1)
    statetraj = deblurrSeq(statetraj);
end
statetraj = binDiscrVal(prm(2),statetraj);
statetraj = refineDiscr(prm(3),statetraj,traj);
if prm(4)
    statetraj = aveStates(traj, statetraj);
end