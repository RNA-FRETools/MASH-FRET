function p = importSim(p,projs)
% p = importSim(p,projs)
%
% Ensure proper import of input projects' Simulation processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define molecule processing parameters applied (prm) and to apply (curr)
for i = projs
    if isempty(p.proj{i}.sim)
        continue
    end
    
    % set default processing parameters
    p.sim.defProjPrm = setDefPrm_sim(p); % interface default
    p.proj{i}.sim.def = p.sim.defProjPrm; % project default
    
    % initializes applied processing parameters 
    if ~isfield(p.proj{i}.sim, 'prm')
        p.proj{i}.sim.prm = {}; % empty param. for all mol.
    end
    
    % correct down-compatibility issues
    p.proj{i} = downCompatibilitySim(p.proj{i});

    % if size of prm is different from def, use def
    p.proj{i}.sim.curr = adjustVal(p.proj{i}.sim.prm,p.proj{i}.sim.def);
end
