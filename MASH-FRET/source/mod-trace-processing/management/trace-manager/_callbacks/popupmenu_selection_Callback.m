function popupmenu_selection_Callback(obj, evd, h_fig)
% Change the current selection according to selected menu

% Created by MH, 24.4.2019

h = guidata(h_fig);

meth = get(obj,'value');

if meth==1 % current
    set([h.tm.text_selectTags,h.tm.popupmenu_selectTags,...
        h.tm.pushbutton_select],'enable','off');
elseif sum(meth==[2,3,4]) % all,none,inverse
    set([h.tm.text_selectTags,h.tm.popupmenu_selectTags],'enable','off');
    set(h.tm.pushbutton_select,'enable','on');
else % condition on tag
    set([h.tm.text_selectTags,h.tm.popupmenu_selectTags,...
        h.tm.pushbutton_select],'enable','on');
end




