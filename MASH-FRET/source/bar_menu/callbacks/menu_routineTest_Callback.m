function menu_routineTest_Callback(obj,evd,module,panel,h_fig)

% set overwirting file option to "always overwrite"
h = guidata(h_fig);
prev_owask = h.param.OpFiles.overwrite_ask;
prev_owa = h.param.OpFiles.overwrite;
h.param.OpFiles.overwrite_ask = false;
h.param.OpFiles.overwrite = true;

% set action display on mute
h.mute_actions = true;
guidata(h_fig,h);

switch module
    case 'sim'
        routinetest_S(h_fig,panel);
    case 'vp'
        routinetest_VP(h_fig,panel);
    case 'tp'
    case 'ha'
    case 'ta'
    case 'menu'
        routinetest_menu(h_fig,panel)
end

% set file overwriting to previous settings
h = guidata(h_fig);
h.param.OpFiles.overwrite_ask = prev_owask;
h.param.OpFiles.overwrite = prev_owa;

% restore action display
h.mute_actions = false;
guidata(h_fig,h);
