function ud_trSetTbl(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
datTbl = {};
col_w = 'auto';
col_name = [];
col_fmt = {};
col_edt = false(size(col_name));
if ~isempty(p.proj)
    proj = p.curr_proj;
    projPrm = p.proj{proj};
    mol = p.curr_mol(proj);
    nC = projPrm.nb_channel;
    incl = {projPrm.coord_incl(mol)};
    coord = projPrm.coord;
    w_incl = 15; w_coord = 43;
    if ~isempty(coord)
        datTbl = num2cell(coord(mol,:));
        col_w = {};
        for n = 1:nC
            col_w = [col_w {w_coord w_coord}];
            col_name = [col_name {['x' num2str(n)]  ['y' num2str(n)]}];
            col_fmt = [col_fmt {'bank' 'bank'}];
        end
        col_name = [{''} col_name];
        col_w = [{w_incl} col_w];
        col_fmt = [{'logical'} col_fmt];
    else
        datTbl = {};
        col_name = {''};
        col_w = {w_incl};
        col_fmt = {'logical'};
    end
    col_edt = true(size(col_name));
    datTbl = [incl datTbl];
    
    p.defProjPrm.mol = p.proj{proj}.curr{mol};
    
    % reorder the cross talk coefficients as the wavelength
    [o,id] = sort(p.proj{proj}.excitations,'ascend'); % chronological index sorted as wl
    mol_prev = p.defProjPrm.mol{5};
    for c = 1:nC
        p.defProjPrm.mol{5}{1}(:,c) = mol_prev{1}(id,c);
        p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
    end
    
    p.defProjPrm.general = p.proj{proj}.fix;
    p.defProjPrm.exp = p.proj{proj}.exp;
    h.param.ttPr = p;
    guidata(h_fig, h);
    
end

set(h.uitable_molCoord, 'Data', datTbl, 'ColumnName', col_name, ...
    'ColumnFormat', col_fmt, 'ColumnEditable', col_edt, 'ColumnWidth', ...
    col_w, 'RowName', []);
 
ud_lstMolStr(p, h.listbox_molNb);