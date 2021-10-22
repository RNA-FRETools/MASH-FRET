function listbox_molNb_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
m0 = p.ttPr.curr_mol(proj);

m1 = get(obj, 'Value');
if isequal(m1, m0)
    return
end

p.ttPr.curr_mol(proj) = m1;

fixStart = p.proj{proj}.TP.fix{2}(6);
if fixStart
    p.proj{proj}.TP.curr{m1}{2}{1}(4) = p.proj{proj}.TP.curr{m0}{2}{1}(4);
end

h.param = p;
guidata(h_fig, h);

ud_trSetTbl(h_fig);
updateFields(h_fig, 'ttPr');
