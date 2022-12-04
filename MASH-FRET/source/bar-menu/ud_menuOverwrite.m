function ud_menuOverwrite(h_fig)

h = guidata(h_fig);
ask = h.param.OpFiles.overwrite_ask;
ow = h.param.OpFiles.overwrite;

if ask 
    set(h.menu_overWrite,'Checked','off')
    set(h.menu_rename,'Checked','off')
    set(h.menu_ask,'Checked','on')
elseif ow
    set(h.menu_overWrite,'Checked','on')
    set(h.menu_rename,'Checked','off')
    set(h.menu_ask,'Checked','off')
elseif ~ow
    set(h.menu_overWrite,'Checked','off')
    set(h.menu_rename,'Checked','on')
    set(h.menu_ask,'Checked','off')
end