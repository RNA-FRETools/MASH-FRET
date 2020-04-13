function pushbutton_applyAll_den_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    if ~h.mute_actions
        choice = questdlg( {['Overwriting denoising parameters of all ' ...
            'molecules erases previous traces processing'], ...
            'Overwrite denoising parameters of all molecule?'}, ...
            'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
        if ~strcmp(choice, 'Apply')
            return
        end
    end
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    nMol = size(p.proj{proj}.coord_incl,2);
    for m = 1:nMol
        p.proj{proj}.curr{m}{1} = p.proj{proj}.curr{mol}{1};
    end
    p.proj{proj}.def.mol{1} = p.proj{proj}.curr{mol}{1};
    h.param.ttPr = p;
    guidata(h_fig, h);
end