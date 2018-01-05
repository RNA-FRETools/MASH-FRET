function popupmenu_TDPdataType_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    if get(obj, 'Value') ~= p.curr_type(proj)
        p.curr_type(proj) = get(obj, 'Value');
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        cla(h.axes_TDPplot1);
        updateFields(h.figure_MASH, 'TDP');
    end
end