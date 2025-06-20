function h = delControlIfHandle(h,name)
% h = delControlIfHandle(h,name)
%
% Identify if structure h contains field name and delete the associated value if it is a handle to a UI element
%
% h: (structure)
% name: (string) name of the field

if ~iscell(name)
    name = {name};
end
for n = 1:numel(name)
    if isfield(h,name{n}) 
        for m = 1:numel(h.(name{n}))
            if ishandle(h.(name{n})(m))
                delete(h.(name{n})(m));
            end
        end
        h = rmfield(h,name{n});
    end
end
