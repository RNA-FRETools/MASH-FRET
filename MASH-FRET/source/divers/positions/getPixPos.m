function pos = getPixPos(obj)
% get input object's property 'position' in pixels

un = get(obj,'units');
set(obj,'units','pixels');
if obj==0
    pos = get(obj,'screensize');
else
    pos = get(obj,'position');
end
set(obj,'units',un);