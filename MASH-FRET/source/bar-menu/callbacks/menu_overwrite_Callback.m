function menu_overwrite_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

switch obj

    case h.menu_overWrite
        p.OpFiles.overwrite_ask = 0;
        p.OpFiles.overwrite = 1;

    case h.menu_rename
        p.OpFiles.overwrite_ask = 0;
        p.OpFiles.overwrite = 0;

    case h.menu_ask
        p.OpFiles.overwrite_ask = 1;
end

h.param = p;
guidata(h_fig,h);

ud_menuOverwrite(h_fig);