function str_html = getHtmlColorStr(str,fntclr,fntwght,varargin)
% str_html = getHtmlColorStr(str,fntclr,fntwght)
% str_html = getHtmlColorStr(str,fntclr,fntwght,bgclr)
%
% Add html tags to color string font and background
%
% str: string to color
% fntclr: font color RGB triplet
% bgclr: background color RGB triplet

% get font color
if all(fntclr>=0 & fntclr<=1)
    fntclr = fntclr*255;
end
r_fnt = num2str(fntclr(1));
g_fnt = num2str(fntclr(2));
b_fnt = num2str(fntclr(3));

% get background color
if ~isempty(varargin)
    rgb_bgclr = varargin{1};
    if all(rgb_bgclr>=0 & rgb_bgclr<=1)
        rgb_bgclr = rgb_bgclr*255;
    end
    r_bg = num2str(rgb_bgclr(1));
    g_bg = num2str(rgb_bgclr(2)); 
    b_bg = num2str(rgb_bgclr(3));
    bgclr = ['rgb(',r_bg,',',g_bg,',',b_bg,')'];
else
    bgclr = 'transparent';
end

% tag string
str_html = [...
    '<html>',...
    '<span style= "',...
        'color: rgb(',r_fnt,',',g_fnt,',',b_fnt,');',...
        'font-weight: ',fntwght,';',...
        'background-color: ',bgclr,';',...
        '">',str,'</span>',...
    '</html>'];

