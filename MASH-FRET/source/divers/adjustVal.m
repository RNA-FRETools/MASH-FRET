function p_input = adjustVal(p_input, p_def)
% Fill missing parameters with default values
% "p_input" >> parameters to fill
% "p_def" >> default parameters
%
% Created the 24th of March 2014 by Mélodie C.A.S. Hadzic
% Last update the 24th of March 2014 by Mélodie C.A.S. Hadzic

if (iscell(p_def) && ~iscell(p_input)) || ...
        (~iscell(p_def) && iscell(p_input))
    p_input = p_def;
    return
end

% ignore differences in strings
if isstring(p_input) && (isstring(p_def) || ~isempty(p_def))
    return
end

% remove dimensions > 0 if array is empty
if size(p_def,1)==0 || size(p_def,2)==0
    if iscell(p_def)
        p_def = {};
    else
        p_def = [];
    end
end
if size(p_input,1)==0 || size(p_input,2)==0
    if iscell(p_input)
        p_input = {};
    else
        p_input = [];
    end
end

if isempty(p_input)
    p_input = p_def;
end
[sz1,sz2,sz3] = size(p_def);
if size(p_input,3)>size(p_def,3)
    p_input = p_input(:,:,1:sz3);
end
if size(p_input,2)>size(p_def,2)
    p_input = p_input(:,1:sz2,:);
end
if size(p_input,1)>size(p_def,1)
    p_input = p_input(1:sz1,:,:);
end

for cz = 1:size(p_def,3)
    if cz > size(p_input,3)
        p_input(:,:,cz:size(p_def,3)) = p_def(:,:,cz:size(p_def,3));
        break;
    else
        for cc = 1:size(p_def(:,:,cz),2)
            if cc > size(p_input,2)
                try
                    p_input(:,cc:size(p_def(:,:,cz),2),cz) = ...
                        p_def(:,cc:size(p_def(:,:,cz),2),cz);
                catch err
                    pouet = 0;
                end
                break;
            else
                for cr = 1:size(p_def(:,cc,cz),1)
                    if cr > size(p_input(:,cc,cz),1)
                        p_input(cr:size(p_def(:,cc,cz),1),cc,cz) = ...
                            p_def(cr:size(p_def(:,cc,cz),1),cc,cz);
                        break;
                    else
                        if ~iscell(p_def(cr,cc,cz)) && ...
                                numel(p_def(cr,cc,cz)) > 1
                            p_input(cr,cc,cz) = adjustVal( ...
                                p_input(cr,cc,cz), p_def(cr,cc,cz));
                            
                        elseif iscell(p_def(cr,cc,cz))
                            p_input{cr,cc,cz} = adjustVal( ...
                                p_input{cr,cc,cz}, p_def{cr,cc,cz});
                        end
                    end
                end
            end
        end
    end
end
p_input = p_input(1:size(p_def,1),1:size(p_def,2),1:size(p_def,3));
