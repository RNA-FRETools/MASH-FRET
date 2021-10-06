function p = importSim(p,projs)
% p = importSim(p,projs)
%
% Ensure proper import of input projects' Simulation processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define molecule processing parameters applied (prm) and to apply (curr)
for i = projs
    
    % initializes current plot
    p.sim.curr_plot(i) = 1;
end