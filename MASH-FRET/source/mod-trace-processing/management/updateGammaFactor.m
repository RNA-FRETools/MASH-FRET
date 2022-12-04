function p = updateGammaFactor(h_fig, mol, p)

% collect current project
proj = p.curr_proj;

% save current processing parameters
p.proj{proj}.TP.prm{mol}(6) = p.proj{proj}.TP.curr{mol}(6);

% calculate gamma factors
p = gammaCorr(h_fig, mol, p);

% save changes to current parameters
p.proj{proj}.TP.curr{mol}(6) = p.proj{proj}.TP.prm{mol}(6);
p.proj{proj}.TP.def.mol(6) = p.proj{proj}.TP.prm{mol}(6);