function p = importVP(p,projs)
% p = importVP(p,projs)
%
% Ensure proper import of input projects' VP processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define molecule processing parameters applied (prm) and to apply (curr)
for i = projs
    if isempty(p.proj{i}.VP)
        continue
    end
    
    % set default processing parameters
    p.VP.defProjPrm = setDefPrm_VP(p); % interface default
    p.proj{i}.VP.def = p.VP.defProjPrm; % project default
    
    % initializes applied processing parameters 
    if ~isfield(p.proj{i}.VP, 'prm')
        p.proj{i}.VP.prm = {}; % empty param
    end
    
    % correct down-compatibility issues
    p.proj{i} = downCompatibilityVP(p.proj{i});

    % if size of prm is different from def, use def
    p.proj{i}.VP.curr = adjustVal(p.proj{i}.VP.prm,p.proj{i}.VP.def);
end
