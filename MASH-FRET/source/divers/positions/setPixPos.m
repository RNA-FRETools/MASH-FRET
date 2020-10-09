function setPixPos(obj,pos)
% set input object's property 'position' to input pixel value

un = get(obj,'units');
set(obj,'units','pixels');
if obj>0
    set(obj,'position',pos);
end
set(obj,'units',un);