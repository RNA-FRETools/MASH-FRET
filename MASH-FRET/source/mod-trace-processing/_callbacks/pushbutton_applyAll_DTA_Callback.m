function pushbutton_applyAll_DTA_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nMol = size(p.proj{proj}.coord_incl,2);

if ~h.mute_actions
    choice = questdlg( {['Overwriting DTA parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite DTA parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    if ~strcmp(choice, 'Apply')
        return
    end
end

for m = 1:nMol
    p.proj{proj}.TP.curr{m}{4} = p.proj{proj}.TP.curr{mol}{4};
end
p.proj{proj}.TP.def.mol{4} = p.proj{proj}.TP.curr{mol}{4};

h.param = p;
guidata(h_fig, h);