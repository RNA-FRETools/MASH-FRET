function popupmenu_bt_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(3) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_cross(h.figure_MASH);
end