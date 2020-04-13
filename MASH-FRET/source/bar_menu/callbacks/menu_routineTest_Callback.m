function menu_routineTest_Callback(obj,evd,module,panel,h_fig)

% save current interface
h = guidata(h_fig);
h_prev = h;
curr_dir = pwd;

% set overwirting file option to "always overwrite"
h.param.OpFiles.overwrite_ask = false;
h.param.OpFiles.overwrite = true;

% set action display on mute
h.mute_actions = true;

% save modifications
guidata(h_fig,h);

switch module
    case 'sim'
        routinetest_S(h_fig,panel);
    case 'vp'
        routinetest_VP(h_fig,panel);
    case 'tp'
        routinetest_TP(h_fig,panel);
    case 'ha'
        routinetest_HA(h_fig,panel);
    case 'ta'
        routinetest_TA(h_fig,panel);
    case 'menu'
        routinetest_menu(h_fig,panel)
end

% restore interface as before executing routine
h_prev.mute_actions = false;
guidata(h_fig,h_prev);
cd(curr_dir);

updateFields(h_fig,'all');
