function p = updateStateSequences(h_fig, mol, p)

% collect current project
proj = p.curr_proj;

% save current processing parameters
p.proj{proj}.prm{mol}(4) = p.proj{proj}.curr{mol}(4);

% get state sequences
p = discrTraces(h_fig, mol, p);

% save changes to current parameters
p.proj{proj}.curr{mol}(4) = p.proj{proj}.prm{mol}(4);
p.proj{proj}.def.mol(4) = p.proj{proj}.prm{mol}(4);