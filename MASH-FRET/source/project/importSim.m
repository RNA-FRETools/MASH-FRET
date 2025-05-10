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

    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;
    
    % set default processing parameters
    p.sim.defProjPrm = adjustcellsize(...
        adjustParam('defProjPrm',cell(nExc,nChan),p.sim),nExc,nChan);
    p.sim.defProjPrm{nExc,nChan} = setDefPrm_sim(p);
    p.proj{i}.sim.def = p.sim.defProjPrm{nExc,nChan}; 
    
    % initializes applied processing parameters 
    if ~isfield(p.proj{i}.sim, 'prm')
        p.proj{i}.sim.prm = {}; % empty param. for all mol.
    end
    p.proj{i}.sim.prm = initDefPrmFields_sim(p.proj{i}.sim.prm);
    
    % correct down-compatibility issues
    p.proj{i}.sim = downCompatibilitySim(p.proj{i}.sim);
    
    % build up currently displayed parameters
    fldnms = fieldnames(p.proj{i}.sim.def);
    for fld = 1:numel(fldnms)
        eval(['p.proj{i}.sim.curr.',fldnms{fld},'= ',...
            'adjustVal(p.proj{i}.sim.prm.',fldnms{fld},',',...
            'p.proj{i}.sim.def.',fldnms{fld},');']); 
    end
end
