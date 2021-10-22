function pushbutton_molNext_Callback(obj, evd, h_fig)

% update by MH, 24.4.2019:: remove double update of molecule list

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nMax = size(p.proj{proj}.coord_incl,2);
mol_prev = p.ttPr.curr_mol(proj);
fixStart = p.proj{proj}.TP.fix{2}(6);

mol = mol_prev + 1;
if mol > nMax
    mol = nMax;
end

if mol==mol_prev
    return
end

p.ttPr.curr_mol(proj) = mol;
if fixStart
    p.proj{proj}.TP.curr{mol}{2}{1}(4) = ...
        p.proj{proj}.TP.curr{mol_prev}{2}{1}(4);
end

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');

