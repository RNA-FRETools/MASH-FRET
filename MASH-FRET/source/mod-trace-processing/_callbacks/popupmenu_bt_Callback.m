function popupmenu_bt_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(3) = val;
    h.param.ttPr = p;
    guidata(h_fig, h);
    ud_cross(h_fig);
end