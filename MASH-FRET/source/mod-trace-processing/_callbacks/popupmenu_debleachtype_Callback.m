function popupmenu_debleachtype_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p.proj{proj}.curr{mol}{2}{1}(2) = val;
    h.param.ttPr = p;
    guidata(h_fig, h);
    ud_bleach(h_fig);
end