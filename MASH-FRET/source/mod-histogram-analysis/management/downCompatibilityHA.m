function p_proj = downCompatibilityHA(p_proj,tpe,tag)
% p_proj = downCompatibilityHA(p_proj,tpe,tag)
%
% Re-arrange processing parameters and analysis results of older projects according to current MASH version.
%
% p_proj: structure containing project's data
% tpe: index in list of data type
% tag: index in list of molecule tag

def = p_proj.def{tag,tpe};
prm = p_proj.prm{tag,tpe};

if ~isstruct(prm)
    return
end

if isfield(prm,'plot') && size(prm.plot,2)==2
    prm.plot = [prm.plot,def.plot{3}];
end

% 5.11.2021: add likelihood calculation
if isfield(prm,'thm_start') && size(prm.thm_start,2)>=4 && ...
        size(prm.thm_start{4},2)==3
    prm.thm_start{4} = [prm.thm_start{4},def.thm_start{4}(4)];
end

p_proj.prm{tag,tpe} = prm;


