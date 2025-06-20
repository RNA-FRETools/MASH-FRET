function setPropIfField(s,fldnm,varargin)
% setPropIfField(s,fldnm,prop,val,...)
%
% Set object specified Properties, Value pair only if it exists as a 
% specified field in the input structure.
%
% s: structure containing objects' handles
%   s.(fldnm{n}): objects' handles
% fldnm: scalar or cell array of strings containing field names
% prop: string containing properties name
% val: properties' value

if ~iscell(fldnm)
    fldnm = {fldnm};
end

N = numel(fldnm);
for n = 1:N
    if isfield(s,fldnm{n})
        for m = 1:numel(varargin)/2
            set(s.(fldnm{n}),varargin{2*m-1},varargin{2*m});
        end
    end
end