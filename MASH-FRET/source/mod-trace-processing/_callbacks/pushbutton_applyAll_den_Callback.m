function pushbutton_applyAll_den_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nMol = size(p.proj{proj}.coord_incl,2);

if ~h.mute_actions
    choice = questdlg( {['Overwriting denoising parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite denoising parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    if ~strcmp(choice, 'Apply')
        return
    end
end

% show process
setContPan('Applying "Denoising" parameters to all molecules...','process',...
    h_fig);

for m = 1:nMol
    p.proj{proj}.TP.curr{m}{1} = p.proj{proj}.TP.curr{mol}{1};
end
p.proj{proj}.TP.def.mol{1} = p.proj{proj}.TP.curr{mol}{1};

h.param = p;
guidata(h_fig, h);

% show success
setContPan(['"Denoising" parameters were successfully appllied to all ',...
    'molecules...'],'success',h_fig);
