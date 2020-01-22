function popupmenu_addSelectTag_Callback(obj,evd,h_fig)

h = guidata(h_fig);

tag = get(obj,'value');

if tag==1 % not tag
    set(h.tm.pushbutton_addSelectTag,'enable','off');
else
    set(h.tm.pushbutton_addSelectTag,'enable','on');
end