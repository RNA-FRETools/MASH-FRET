function prm = initDefPrmFields_VP(prm)
% prm = initDefPrmFields_VP(prm)
%
% Set fields in video processing parameter structure if not existing
%
% prm: video processing parameter structure

prm.plot = adjustParam('plot',cell(1,1),prm);
prm.edit = adjustParam('gen_dt',cell(1,2),prm);
prm.gen_crd = adjustParam('gen_dat',cell(1,3),prm);
prm.gen_int = adjustParam('exp',cell(1,2),prm);
prm.res_crd = [];
prm.res_int = [];
prm.res_plot = cell(1,2);