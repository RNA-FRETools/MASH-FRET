function pos = getPixPos(obj)
% get input object's property 'position' in pixels

un = get(obj,'units');
set(obj,'units','pixels');
pos = get(obj,'position');
set(obj,'units',un);