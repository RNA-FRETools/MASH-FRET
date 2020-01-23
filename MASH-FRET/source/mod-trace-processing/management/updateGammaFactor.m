function p = updateGammaFactor(h_fig, mol, p)

% collect current project
proj = p.curr_proj;

% save current processing parameters
p.proj{proj}.prm{mol}(6) = p.proj{proj}.curr{mol}(6);

% calculate gamma factors
p = gammaCorr(h_fig, mol, p);

% save changes to current parameters
p.proj{proj}.curr{mol}(6) = p.proj{proj}.prm{mol}(6);
p.proj{proj}.def.mol(6) = p.proj{proj}.prm{mol}(6);