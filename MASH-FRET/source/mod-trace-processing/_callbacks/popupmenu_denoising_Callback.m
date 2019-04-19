function popupmenu_denoising_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    mol = p.curr_mol(proj);
    p.proj{proj}.curr{mol}{1}{1}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_denoising(h.figure_MASH);
end