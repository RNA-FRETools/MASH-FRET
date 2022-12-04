function popupmenu_bleachChan_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
method = p.proj{proj}.TP.curr{mol}{2}{1}(2);

if method~=2 % Threshold
    return
end

p.proj{proj}.TP.curr{mol}{2}{1}(3) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

ud_bleach(h_fig);