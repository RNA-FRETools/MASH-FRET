function drawMask(h_fig,x,y,D)

% defaults
clr = [0.5,0.5,0.5];
a = 0.5;
width = 2;

h = guidata(h_fig);

xrange = [str2num(get(h.tm.edit_xrangeLow,'string')) ...
    str2num(get(h.tm.edit_xrangeUp,'string'))];
yrange = [str2num(get(h.tm.edit_yrangeLow,'string')) ...
    str2num(get(h.tm.edit_yrangeUp,'string'))];

xrange(xrange==-Inf) = x(1)-1;
yrange(yrange==-Inf) = y(1)-1;
xrange(xrange==Inf) = x(2)+1;
yrange(yrange==Inf) = y(2)+1;

if xrange(1)>=xrange(2)
    xrange(1) = x(1);
    xrange(2) = x(2);
    set(h.tm.edit_xrangeLow,'string',num2str(xrange(1)));
    set(h.tm.edit_xrangeUp,'string',num2str(xrange(2)));
end
if yrange(1)>=yrange(2)
    yrange(1) = y(1);
    yrange(2) = y(2);
    set(h.tm.edit_yrangeLow,'string',num2str(yrange(1)));
    set(h.tm.edit_yrangeUp,'string',num2str(yrange(2)));
end

set(h.tm.axes_histSort,'nextplot','add');

switch D
    case 1 %1D mask
        xdata = [x(1)-1,xrange(1),xrange(1),xrange(2),xrange(2),x(2)+1];
        ydata = [y(2)+1,y(2)+1,-1,-1,y(2)+1,y(2)+1];
        area(h.tm.axes_histSort,xdata,ydata,'edgecolor',clr,'facecolor',...
            clr,'facealpha',a,'linestyle','none','basevalue',0,'hittest',...
            'off','pickableparts','none');
        set(h.tm.axes_histSort,'ylim',[0,y(2)]);
    
    case 2 % 2D mask
        area(h.tm.axes_histSort,[x(1),xrange(1)],y([2,2]),'facecolor',clr,...
            'facealpha',a,'linestyle','none','basevalue',y(1),'hittest',...
            'off','pickableparts','none');

        area(h.tm.axes_histSort,xrange([1,2]),yrange([1,1]),'facecolor',...
            [0.5,0.5,0.5],'facealpha',a,'linestyle','none','basevalue',...
            y(1),'hittest','off','pickableparts','none');

        area(h.tm.axes_histSort,[xrange(2),x(2)],[y(2),y(2)],'facecolor',...
            clr,'facealpha',a,'linestyle','none','basevalue',y(1),'hittest',...
            'off','pickableparts','none');

        % draw upper area: only patch allows transparency AND different baseline
        patch(h.tm.axes_histSort,'xdata',xrange([1,2,2,1]),'ydata',...
            [y([2,2]),yrange([2,2])],'facecolor',clr,'facealpha',a,...
            'linestyle','none','hittest','off');

        % draw recatngle around the target
        pos = [xrange(1),yrange(1),(xrange(2)-xrange(1)),...
            (yrange(2)-yrange(1))];
        pos(pos==Inf) = max([x(2) y(2)]);
        pos(pos==-Inf) = min([x(1) y(1)]);

        rectangle(h.tm.axes_histSort,'position',pos,'edgecolor',clr,...
            'linewidth',width,'hittest','off');
end

set(h.tm.axes_histSort,'nextplot','replacechildren');

