function str_w = wrapActionString(mode,he,hndls,varargin)

% default
wbar = 18; % width of sliding bar (pixels)

if strcmp(mode,'resize')
    str0 = get(he,'string');
    str_uw = {};
    for s = 1:numel(str0)
        if str0{s}(1)>=65 && str0{s}(1)<=90 % capital letter
            str_uw = cat(2,str_uw,str0{s});
        else
            str_uw{end} = [str_uw{end},' ',str0{s}];
        end
    end
else
    str_uw = varargin{1};
end

pos = getPixPos(he);
str_w = {};
for s = 1:numel(str_uw)
    str_w = cat(2,str_w,wrapStrToWidth(str_uw{s},he.FontUnits,...
        he.FontSize,he.FontWeight,pos(3)-wbar,'gui',hndls));
end
