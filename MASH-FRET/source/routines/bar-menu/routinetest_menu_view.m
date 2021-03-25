function routinetest_menu_view(h_fig)
% routinetest_menu_view(h_fig,prefix)
%
% Tests menu callback
%
% h_fig: handle to main figure

h = guidata(h_fig);
menu_showActPan_Callback(h.menu_showActPan,[],h_fig);
menu_showActPan_Callback(h.menu_showActPan,[],h_fig);