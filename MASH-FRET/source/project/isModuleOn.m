function isOn = isModuleOn(p,module)
% isOn = isModuleOn(p,module)
% 
% Check if the input module is available for use.
%
% p: interface parameters structure
% module: 'sim','VP','TP','HA' or 'TA'

isOn = false;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
if ~(isfield(p.proj{proj},module) && ...
        ~isempty(eval(['p.proj{proj}.',module])))
    return
end

isOn = true;