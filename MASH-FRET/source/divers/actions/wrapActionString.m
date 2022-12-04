function str_w = wrapActionString(mode,he,hndls,varargin)

% default
wbar = 18; % width of sliding bar (pixels)

if strcmp(mode,'resize')
    str_uw = get(he,'userdata');
else
    str_uw = varargin{1};
end

pos = getPixPos(he);
str_w = {};
for s = 1:numel(str_uw)
    str_w = cat(2,str_w,wrapStrToWidth(str_uw{s},he.FontUnits,...
        he.FontSize,he.FontWeight,pos(3)-wbar,'gui',hndls));
end
