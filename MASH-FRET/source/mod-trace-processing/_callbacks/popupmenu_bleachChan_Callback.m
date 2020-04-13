function popupmenu_bleachChan_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 2 % Threshold
        val = get(obj, 'Value');
        p.proj{proj}.curr{mol}{2}{1}(3) = val;
        h.param.ttPr = p;
        guidata(h_fig, h);
        ud_bleach(h_fig);
    end
end