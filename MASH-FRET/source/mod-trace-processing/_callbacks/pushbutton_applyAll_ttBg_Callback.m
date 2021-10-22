function pushbutton_applyAll_ttBg_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nMol = size(p.proj{proj}.coord_incl,2);

if ~h.mute_actions
    choice = questdlg( {['Overwriting background parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite background parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    if ~strcmp(choice, 'Apply')
        return
    end
end
for m = 1:nMol
    p.proj{proj}.TP.curr{m}{3} = p.proj{proj}.TP.curr{mol}{3};
end
p.proj{proj}.TP.def.mol{3} = p.proj{proj}.TP.curr{mol}{3};

h.param = p;
guidata(h_fig, h);
