function popupmenu_TP_subImg_channel_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

if p.proj{p.curr_proj}.is_coord 
    ud_subImg(h_fig);
end