function menu_routineTest_Callback(obj,evd,module,panel,h_fig)

% save current interface
h = guidata(h_fig);
h_prev = h;
curr_dir = pwd;

% get current module
chld = h_fig.Children;
for c = 1:numel(chld)
    if strcmp(chld(c).Type,'uicontrol') && ...
            strcmp(chld(c).Style,'togglebutton') && chld(c).Value==1
        break
    end
end
h_tb = chld(c);

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

h = guidata(h_fig);
h.param = ud_projLst(h.param, h.listbox_proj);
guidata(h_fig,h);

switchPan(h_tb,[],h_fig);

updateFields(h_fig,'all');
