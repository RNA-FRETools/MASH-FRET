function pushbutton_BA_show_Callback(obj, evd, h_fig)
% pushbutton_BA_show_Callback([],[],h_fig)
% pushbutton_BA_show_Callback(file_out,[],h_fig)
%
% h_fig = handle to main figure
% file_out: {1-by-1} destination image file for dark trace figure

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

p = h.param;
if ~isempty(p.proj)
    if iscell(obj)
        coord = dispDark_BA(g.figure_bgopt,obj{1});
    else
        coord = dispDark_BA(g.figure_bgopt);
    end
    m = g.curr_m;
    l = g.curr_l;
    c = g.curr_c;
    g.param{1}{m}(l,c,4) = coord(1);
    g.param{1}{m}(l,c,5) = coord(2);
end
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);


