function p_proj = downCompatibilityTDP(p_proj,tpe,tag)

def = p_proj.def{tag,tpe};
prm = p_proj.prm{tag,tpe};

if ~isstruct(prm)
    return
end

if isfield(prm,'plot') && size(prm.plot{1},1)<4
    prm.plot = def.plot;
end
% add boba parameters if none
if isfield(prm,'clst_start') && size(prm.clst_start,2)<8
    prm.clst_start{1}(6:8) = def.clst_start{1}(6:8);
end

% restructure old fit results
if isfield(prm,'clst_res') && ~isempty(prm.clst_res{1}) && ...
        ~isstruct(prm.clst_res{1})

    % initialize new result structure
    Jmax = prm.clst_start{1}(3);
    Jopt = size(prm.clst_res{1}(:,1),1);
    model.mu = cell(1,Jmax);
    model.fract = cell(1,Jmax);
    model.clusters = cell(1,Jmax);

    % place old results in new structure
    model.mu{Jopt} = prm.clst_res{1}(:,1);
    model.fract{Jopt} = prm.clst_res{1}(:,2);
    model.clusters{Jopt} = prm.clst_res{2};

    method = prm.clst_start{1}(1);

    if method==1
        model.a = [];
        model.o = [];
        model.BIC = [];

    else
        model.a{Jopt} = prm.clst_res{3}.a;
        model.o{Jopt} = prm.clst_res{3}.o;
        model.BIC(Jopt) = prm.clst_res{3}.BIC;
    end

    prm.clst_res{1} = model;
    prm.clst_res{2} = prm.clst_res{3}.boba_k;
    prm.clst_res{3} = Jopt;
end

% 27.1.2020: move model used in kinetic analysis and current transition,
% add state-dependency option
if isfield(prm,'kin_start') && size(prm.kin_start,2)>=2 && ...
        size(prm.kin_start{1},2)<2
    J = prm.clst_res{3};
    curr_k = prm.clst_start{1}(4);
    kin_start = prm.kin_start;
    prm.kin_start = cell(1,2);
    prm.kin_start{1} = kin_start;
    prm.kin_start{2} = [J,curr_k];
    prm.clst_start{1}(4) = true; % state dependency
end

% 28.1.2020: add cluster diagonal and log likelihood options
if isfield(prm,'clst_start') && size(prm.clst_start,2)<10
    prm.clst_start{1} = cat(2,prm.clst_start{1},[true 1]); % state dependency
end

p_proj.prm{tag,tpe} = prm;


