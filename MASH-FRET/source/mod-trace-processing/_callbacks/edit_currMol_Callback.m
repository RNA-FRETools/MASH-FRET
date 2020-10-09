function edit_currMol_Callback(obj, evd, h_fig)

%% Last update by MH, 24.4.2019
% >> remove double update of molecule list
%%

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val))
    proj = p.curr_proj;
    mol_prev = p.curr_mol(proj);
    if ~isequal(val, mol_prev)
        nMax = size(p.proj{proj}.coord_incl,2);
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 ...
                && val <= nMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Molecule number must be > 0 and <= ' ...
                num2str(nMax)], h_fig, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.curr_mol(proj) = val;
            fixStart = p.proj{proj}.fix{2}(6);
            if fixStart
                p.proj{proj}.curr{val}{2}{1}(4) = ...
                    p.proj{proj}.curr{mol_prev}{2}{1}(4);
            end
            h.param.ttPr = p;
            guidata(h_fig, h);
            
            % cancelled by MH, 24.4.2019
%             ud_trSetTbl(h_fig);

            updateFields(h_fig, 'ttPr');
        end
    end
end