function setIfEnabled(obj,prop,val,varargin)
% setIfEnabled(obj,prop,val)
% setIfEnabled(obj,prop,val,callback)
%
% Set object's property if object is enable.
% Object's callback can be executed after setting.
%
% obj: handle to object
% prop: property (string)
% val: property's new value
% callback: (1) to execute object's callback, (0) otherwise

if ~strcmp(get(obj,'enable'),'on')
    return
end

set(obj,prop,val);

if ~isempty(varargin) && varargin{1}
    funandargs = getProp(obj,'callback');
    cbfun = funandargs{1,1};
    args = funandargs(2:end,1);
    str_arg = '';
    for arg = 1:size(args,2)
        if arg>1
            str_arg = cat(2,str_arg,',');
        end
        str_arg = cat(2,str_arg,sprintf('args{%i,1}',arg));
    end
    cbfun(obj,[],eval(str_arg));
end
