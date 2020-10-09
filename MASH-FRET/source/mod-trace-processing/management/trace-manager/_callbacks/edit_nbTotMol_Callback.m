function edit_nbTotMol_Callback(obj, evd, h_fig)

h = guidata(h_fig);
nb_mol = numel(h.tm.molValid);

nb_mol_disp = str2num(get(obj, 'String'));
if nb_mol_disp > nb_mol
    nb_mol_disp = nb_mol;
end

updatePanel_single(h_fig, nb_mol_disp);

if nb_mol <= nb_mol_disp || nb_mol_disp == 0
    min_step = 1;
    maj_step = 1;
    min_val = 0;
    max_val = 1;
    set(h.tm.slider, 'Visible', 'off');
else
    set(h.tm.slider, 'Visible', 'on');
    min_val = 1;
    max_val = nb_mol-nb_mol_disp+1;
    min_step = 1/(max_val-min_val);
    maj_step = nb_mol_disp/(max_val-min_val);
end

set(h.tm.slider, 'Value', max_val, 'Max', max_val, 'Min', min_val, ...
    'SliderStep', [min_step maj_step]);

drawMask_slct(h_fig)
plotDataTm(h_fig);

