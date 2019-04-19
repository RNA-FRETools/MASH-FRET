function menu_overwrite_Callback(obj, evd, h)

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

guidata(h.figure_MASH,h);
ud_menuOverwrite(h.figure_MASH);