function menu_routineTest_Callback(obj,evd,module,panel,h_fig)

switch module
    case 'sim'
        routinetest_S(h_fig,panel);
    case 'vp'
    case 'tp'
    case 'ha'
    case 'ta'
end