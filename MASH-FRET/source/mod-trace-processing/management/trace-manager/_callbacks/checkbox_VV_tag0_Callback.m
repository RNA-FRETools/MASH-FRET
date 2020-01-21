function checkbox_VV_tag0_Callback(obj,evd,h_fig)

h = guidata(h_fig);

switch get(obj,'value')
    case 1
        set(obj,'fontweight','bold');
        set(h.tm.edit_VV_tag0,'enable','inactive');
    case 0
        set(obj,'fontweight','normal');
        set(h.tm.edit_VV_tag0,'enable','off');
end

plotData_videoView(h_fig);

