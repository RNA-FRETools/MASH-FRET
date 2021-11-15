function dic = setKey(dic,varargin)
% dic = setKey(dic,key1,val1,key2,val2,...)
%
% Set key identified by string "key" in dictionary "dic" to value "val"

K = floor(numel(varargin)/2);

for k = 1:K
    key = varargin{2*k-1};
    val = varargin{2*k};
    
    % look for existing key in dictionary
    if isempty(dic)
        id = [];
    else
        id = find(contains(dic(:,1),key));
    end
    if isempty(id) % not existing: create key,value pair
        dic = cat(1,dic,{key,val});
    else % existing: set key value
        dic{id(1),2} = val;
    end
end