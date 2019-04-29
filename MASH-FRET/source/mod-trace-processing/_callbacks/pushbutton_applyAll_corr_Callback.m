function pushbutton_applyAll_corr_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    choice = questdlg( {['Overwriting factor parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite factor parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');

    if strcmp(choice, 'Apply')
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        nMol = size(p.proj{proj}.coord_incl,2);
        for m = 1:nMol
            p.proj{proj}.curr{m}{5} = p.proj{proj}.curr{mol}{5};
        end
        p.proj{proj}.def.mol{5} = p.proj{proj}.curr{mol}{5};
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
    end
end