function axes_TDPplot1_ButtonDownFcn(obj,evd,h_fig)

isrightclick = strcmp(get(h_fig,'selectiontype'),'alt');
if isrightclick
    set(obj,'userdata',false);
else
    set(obj,'userdata',true);
end