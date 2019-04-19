function popupmenu_TP_subImg_channel_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord 
    ud_subImg(h.figure_MASH);
end