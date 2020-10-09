function figure_MASH_WindowButtonUpFcn(obj,evd)

h = guidata(obj);

rightclick = strcmp(get(obj,'selectiontype'),'alt');

if rightclick
    % show uicontextmenu
    pos = get(obj,'currentpoint');

    % show appropriate context menu
    posfig = getPixPos(obj);
    set(h.cm_zoom,'position',[pos(1)*posfig(3),pos(2)*posfig(4)],'visible',...
        'on');

else
    % inform TDP axes that click action is completed
    ud = get(h.axes_TDPplot1,'userdata');
    ud{2} = false;
    set(h.axes_TDPplot1,'userdata',ud);
end
