function pushbutton_TTgen_loadOpt_Callback(obj,evd,h_fig)

% display process
setContPan('Open import options window...','process',h_fig);

openItgOpt(obj,evd,h_fig);

% display success
setContPan('Import options window is ready!','success',h_fig);