function popup_molTag_Callback(obj,evd,h_fig)
% Updates the tag color in corresponding edit field

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% control empty tag
tag = get(obj,'value');
str_pop = get(obj, 'string');
if strcmp(str_pop{tag},'no default tag') || ...
        strcmp(str_pop{tag},'select tag')
    set(h.tm.pushbutton_tagClr,'enable','off','backgroundcolor',...
        get(h_fig,'color'),'foregroundcolor','black');
    return;
else
    tag = tag-1;
end

% update edit field background color
clr_hex = h.tm.molTagClr{tag}(2:end);
if sum(double((hex2rgb(clr_hex)/255)>0.5))==3
    fntClr = 'black';
else
    fntClr = 'white';
end
set(h.tm.pushbutton_tagClr,'enable','on','backgroundcolor',...
    hex2rgb(clr_hex)/255,'foregroundcolor',fntClr);

