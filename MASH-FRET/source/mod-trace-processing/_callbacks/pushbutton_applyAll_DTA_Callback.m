function pushbutton_applyAll_DTA_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    choice = questdlg( {['Overwriting DTA parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite DTA parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');

    if strcmp(choice, 'Apply')
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        nMol = size(p.proj{proj}.coord_incl,2);
        for m = 1:nMol
            p.proj{proj}.curr{m}{4} = p.proj{proj}.curr{mol}{4};
        end
        p.proj{proj}.def.mol{4} = p.proj{proj}.curr{mol}{4};
        h.param.ttPr = p;
        guidata(h_fig, h);
    end
end