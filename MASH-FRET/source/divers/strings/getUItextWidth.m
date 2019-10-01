function [w_txt,h_txt] = getUItextWidth(str,fntUn,fntSz,fntWght)
% returns text-styled uicontrol's width in pixel.

w_txt = 0;
h_txt = 0;

pixperchar = 3; % avergaged pixel width of a character
mg_y = 5/21; % top and bottom padding in relative units
incr = 2;

% add dummy space to spaceless strings for textwrap function to work
if isempty(strfind(str,' '))
    txt = cat(2,str,' .');
else
    txt = str;
end

switch fntUn
    case 'pixels'
        h_txt = (1+mg_y)*fntSz;
    case 'points'
        h_txt = (1+mg_y)*4*fntSz/3;
    otherwise
        disp('font units is not supported');
        return;
end

min_w = pixperchar*length(txt);
postxt = [0 0 min_w h_txt];
outstr = [' ';' '];

while numel(outstr)>1
    dummy = uicontrol('style','text','visible','off','fontunits',fntUn,...
        'fontsize',fntSz,'fontweight',fntWght,'string',txt,'position',...
        postxt);
    outstr = textwrap(dummy,{txt});
    delete(dummy);
    postxt(3) = postxt(3) + incr;
end

w_txt = postxt(3);

% create uicontrol to verrify calculated dimensions:

% uicontrol('style','text','visible','on','fontunits',fntUn,'fontsize',...
%     fntSz,'fontweight',fntWght,'string',str,'position',postxt,...
%     'backgroundcolor',[0,1,0]);
