function pushbutton_applyAll_corr_Callback(obj, evd, h_fig)

% Last update: by MH, 10.1.2020
% >> adapt code to new parameter structure (parameters for factor 
%  corrections in 6th cell)

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    if ~h.mute_actions
        choice = questdlg( {['Overwriting factor parameters of all ' ...
            'molecules erases previous traces processing'], ...
            'Overwrite factor parameters of all molecule?'}, ...
            'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
        if ~strcmp(choice, 'Apply')
            return
        end
    end
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    nMol = size(p.proj{proj}.coord_incl,2);
    for m = 1:nMol
        p.proj{proj}.curr{m}{6} = p.proj{proj}.curr{mol}{6};
    end
    p.proj{proj}.def.mol{6} = p.proj{proj}.curr{mol}{6};
    h.param.ttPr = p;
    guidata(h_fig, h);
end