function handles = getHandleWithPropVal(prnt,prop,val)

handles = [];

for p = 1:numel(prnt)
    if isprop(prnt(p),prop) && isequal(prnt(p).(prop),val)
        handles = cat(2,handles,prnt(p));
    end
    if isprop(prnt(p),'Children')
        handles = cat(2,handles,getHandleWithPropVal(prnt(p).Children,prop,...
            val));
    end
end

