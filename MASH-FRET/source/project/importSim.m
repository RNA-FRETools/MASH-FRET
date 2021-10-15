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
    if isfield(p.sim,'defProjPrm')
        p.proj{i}.sim.def = setDefPrm_sim(p.sim.defProjPrm); 
    else
        p.proj{i}.sim.def = setDefPrm_sim([]); 
    end
    
    % initializes applied processing parameters 
    if ~isfield(p.proj{i}.sim, 'prm')
        p.proj{i}.sim.prm = {}; % empty param. for all mol.
    end
    
    % correct down-compatibility issues
    p.proj{i}.sim = downCompatibilitySim(p.proj{i}.sim);
    
    % build up currently displayed parameters
    p.proj{i}.sim.curr = setDefPrm_sim(p.proj{i}.sim.prm); 
end
