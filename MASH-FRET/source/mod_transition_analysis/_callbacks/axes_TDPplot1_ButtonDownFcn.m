function axes_TDPplot1_ButtonDownFcn(obj,evd,h_fig)

isrightclick = strcmp(get(h_fig,'selectiontype'),'alt');
ud = get(obj,'userdata');
if isrightclick
    ud{2} = false;
else
    ud{2} = true;
end
set(obj,'userdata',ud);