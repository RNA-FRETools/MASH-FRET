function pushbutton_molPrev_Callback(obj, evd, h_fig)

%% Last update by MH, 24.4.2019
% >> remove double update of molecule list
%%
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj) - 1;
    if mol < 1
        mol = 1;
    end
    mol_prev = p.curr_mol(proj);
    if mol ~= mol_prev
        p.curr_mol(proj) = mol;
        fixStart = p.proj{proj}.fix{2}(6);
        if fixStart
            p.proj{proj}.curr{mol}{2}{1}(4) = ...
                p.proj{proj}.curr{mol_prev}{2}{1}(4);
        end
        h.param.ttPr = p;
        guidata(h_fig, h);
        
        % cancelled by MH, 24.4.2019
%         ud_trSetTbl(h_fig);

        updateFields(h_fig, 'ttPr');
    end
end