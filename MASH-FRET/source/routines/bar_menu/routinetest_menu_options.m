function routinetest_menu_options(h_fig)
% routinetest_menu_options(h_fig)
%
% Tests menu callbacks
%
% h_fig: handle to main figure

h = guidata(h_fig);

prev_owask = h.param.OpFiles.overwrite_ask;
prev_owa = h.param.OpFiles.overwrite;

menu_overwrite_Callback(h.menu_rename, [], h_fig);
menu_overwrite_Callback(h.menu_ask, [], h_fig);
menu_overwrite_Callback(h.menu_overWrite, [], h_fig);

% restore overwriting options
h = guidata(h_fig);
h.param.OpFiles.overwrite_ask = prev_owask;
h.param.OpFiles.overwrite = prev_owa;
guidata(h_fig,h);