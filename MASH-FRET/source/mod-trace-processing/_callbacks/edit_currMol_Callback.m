function edit_currMol_Callback(obj, evd, h_fig)

%% Last update by MH, 24.4.2019
% >> remove double update of molecule list
%%

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol_prev = p.ttPr.curr_mol(proj);
nMax = size(p.proj{proj}.coord_incl,2);
fixStart = p.proj{proj}.TP.fix{2}(6);

if isequal(val, mol_prev)
    return
end

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val))
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 ...
        && val <= nMax)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Molecule number must be > 0 and <= ' ...
        num2str(nMax)], h_fig, 'error');
    return
end

p.ttPr.curr_mol(proj) = val;

if fixStart
    p.proj{proj}.TP.curr{val}{2}{1}(4) = ...
        p.proj{proj}.TP.curr{mol_prev}{2}{1}(4);
end
h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');
