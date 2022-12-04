function prm = initDefPrmFields_VP(prm)
% prm = initDefPrmFields_VP(prm)
%
% Set fields in video processing parameter structure if not existing
%
% prm: video processing parameter structure

prm.plot = adjustParam('plot',cell(1,1),prm);
prm.edit = adjustParam('edit',cell(1,2),prm);
prm.gen_crd = adjustParam('gen_crd',cell(1,3),prm);
prm.gen_int = adjustParam('gen_int',cell(1,2),prm);
prm.res_crd = adjustParam('res_crd',cell(1,4),prm);
prm.res_plot = adjustParam('res_plot',cell(1,3),prm);