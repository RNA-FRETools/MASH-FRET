function h_but = setPanCllpsButtons(handles,h_fig)

% initializes output
h_but = [];

% defaults
wbut = 25;
hbut = 25;

for h_pan = handles
    pospan = getPixPos(h_pan);
    x = pospan(1)+pospan(3)-wbut;
    y = pospan(2)+pospan(4)-hbut;
    
    h_but = cat(2,h_but,...
        uicontrol('parent',h_pan.Parent,'style','pushbutton','units',...
        'pixels','position',[x,y,wbut,hbut],'string',char(9660),...
        'callback',{@pushbutton_panelCollapse_Callback,h_fig},'userdata',...
        {h_pan,h_pan.Position(4)})...
    );
    set(h_but(end),'units','normalized');
    
    h_pan.UserData = h_but(end);
end