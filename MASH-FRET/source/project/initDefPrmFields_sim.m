function prm = initDefPrmFields_sim(prm)
% prm = initiDefPrmFields_sim(prm)
%
% Set fields in simulation parameter structure if not existing
%
% prm: simulation parameter structure

prm.plot = adjustParam('plot',cell(1,1),prm);
prm.gen_dt = adjustParam('gen_dt',cell(1,2),prm);
prm.gen_dat = adjustParam('gen_dat',cell(1,3),prm);
prm.exp = adjustParam('exp',cell(1,2),prm);
prm.res_dt = cell(1,3);
prm.res_dat = cell(1,3);
prm.res_plot = cell(1,2);