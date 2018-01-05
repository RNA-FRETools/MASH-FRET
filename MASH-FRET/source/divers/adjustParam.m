function val = adjustParam(fieldName, val, param)
% Check for existence of parameter and set it
% "fieldName" >> field corresponding to the parameter
% "val" >> default value of the parameter
% "param" >> structure containing the parameter
% "val" >> final value of the parameter

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

if isfield(param, fieldName)
    val = getfield(param, fieldName);
end