function p_proj = downCompatibilityHA(p_proj,tpe,tag)
% p_proj = downCompatibilityHA(p_proj,tpe,tag)
%
% Re-arrange processing parameters and analysis results of older projects according to current MASH version.
%
% p_proj: structure containing project's data
% tpe: index in list of data type
% tag: index in list of molecule tag

def = p_proj.HA.def{tag,tpe};
prm = p_proj.HA.prm{tag,tpe};

if ~isstruct(prm)
    return
end

if isfield(prm,'plot') && size(prm.plot,2)==2
    prm.plot = [prm.plot,def.plot{3}];
end

p_proj.TA.prm{tag,tpe} = prm;


