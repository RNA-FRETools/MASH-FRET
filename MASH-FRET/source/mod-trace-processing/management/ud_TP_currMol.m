function ud_TP_currMol(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

% control TP
if ~isModuleOn(p,'TP')
    return
end

% collect experiment settings
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);

% update current molecule
set(h.edit_currMol,'string',num2str(mol));