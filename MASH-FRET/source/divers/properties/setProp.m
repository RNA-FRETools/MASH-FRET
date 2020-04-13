function setProp(h, prop, val, varargin)

h = reshape(h,1,numel(h));

condition = ~isempty(varargin) && size(varargin,2) == 2 && ...
    ~isempty(varargin{1}) && ~isempty(varargin{2});
if condition
    propCond = varargin{1};
    valCond = varargin{2};
else
    propCond = [];
    valCond = [];
end

for i = 1:numel(h)
    if isprop(h(i),'Children')
        h_obj = get(h(i), 'Children');
        if ~isempty(h_obj)
            setProp(h_obj, prop, val, propCond, valCond);
        end
    end
    if condition && isprop(h(i),prop) && isprop(h(i), propCond) && ...
            isequal(get(h(i), propCond), valCond)
        set(h(i), prop, val);
        
    elseif ~condition && isprop(h(i),prop)
        set(h(i), prop, val);
    end
end
