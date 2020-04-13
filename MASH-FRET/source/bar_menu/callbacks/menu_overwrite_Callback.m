function menu_overwrite_Callback(obj, evd, h_fig)

h = guidata(h_fig);

switch obj

    case h.menu_overWrite
        h.param.OpFiles.overwrite_ask = 0;
        h.param.OpFiles.overwrite = 1;

    case h.menu_rename
        h.param.OpFiles.overwrite_ask = 0;
        h.param.OpFiles.overwrite = 0;

    case h.menu_ask
        h.param.OpFiles.overwrite_ask = 1;
end

guidata(h_fig,h);
ud_menuOverwrite(h_fig);