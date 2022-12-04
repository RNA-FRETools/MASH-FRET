function ESlinRegOpt(h_fig)

% display action
setContPan('Openning linear regression options...','process',h_fig);

h_fig2 = build_ESlinRegOpt(h_fig);

setDefPrm_ESlinRegOpt(h_fig,h_fig2);

ud_EScalc(h_fig,h_fig2);

ud_ESlinRegOpt(h_fig,h_fig2);

% display action
setContPan('Linear regression options are now opened!','success',h_fig);


