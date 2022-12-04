function p = importVP(p,projs)
% p = importVP(p,projs)
%
% Ensure proper import of input projects' VP processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define molecule processing parameters applied (prm) and to apply (curr)
for i = projs
    if ~p.proj{i}.is_movie
        p.proj{i}.VP = [];
    end
    if isempty(p.proj{i}.VP)
        continue
    end
    
    % set default processing parameters
    p.VP.defProjPrm = setDefPrm_VP(p.proj{i},p); % interface default
    p.proj{i}.VP.def = p.VP.defProjPrm; % project default
    
    % initializes applied processing parameters 
    if ~isfield(p.proj{i}.VP, 'prm')
        p.proj{i}.VP.prm = {}; % empty param
    end
    p.proj{i}.VP.prm = initDefPrmFields_VP(p.proj{i}.VP.prm,...
        p.proj{i}.VP.def);
    
    % correct down-compatibility issues
    p.proj{i} = downCompatibilityVP(p.proj{i});

    % build up currently displayed parameters
    fldnms = fieldnames(p.proj{i}.VP.def);
    fldnms(contains(fldnms,'res_plot')) = [];
    fldnms(contains(fldnms,'res_crd')) = [];
    for fld = 1:numel(fldnms)
        eval(['p.proj{i}.VP.curr.',fldnms{fld},'= ',...
            'adjustVal(p.proj{i}.VP.prm.',fldnms{fld},',',...
            'p.proj{i}.VP.def.',fldnms{fld},');']); 
    end
    
    % get previously calculated images
    p.proj{i}.VP.curr.res_plot = p.proj{i}.VP.prm.res_plot;
    if isempty(p.proj{i}.VP.curr.res_plot{2})
        p.proj{i}.VP.curr.res_plot{2} = p.proj{i}.VP.def.res_plot{2};
    end
    
    % get previously calculated coordinates
    p.proj{i}.VP.curr.res_crd = p.proj{i}.VP.prm.res_crd;
    if isempty(p.proj{i}.VP.curr.res_crd{4})
        p.proj{i}.VP.curr.res_crd{4} = p.proj{i}.VP.def.res_crd{4};
    end
end
