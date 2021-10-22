function checkbox_photobl_fixStart_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPt.curr_mol(proj);
nMol = size(p.proj{proj}.coord_incl,2);

val = get(obj, 'Value');
if val
    for m = 1:nMol
         p.proj{proj}.TP.curr{m}{2}{1}(4) = ...
             p.proj{proj}.TP.curr{mol}{2}{1}(4);
    end
else
    for m = 1:nMol
        if ~isempty(p.proj{proj}.TP.prm{m})
            p.proj{proj}.TP.curr{m}{2}{1}(4) = ...
                p.proj{proj}.TP.prm{m}{2}{1}(4);
        else
            p.proj{proj}.TP.curr{m}{2}{1}(4) = ...
                p.proj{proj}.TP.curr{mol}{2}{1}(4);
        end
    end
end

p.proj{proj}.TP.fix{2}(6) = val;

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');
