function pushbutton_linreg_ESopt_Callback(obj,evd,h_fig,h_fig2)

% display action
setContPan('Updating correction factor calculations...','process',h_fig);

ud_EScalc(h_fig,h_fig2);
ud_ESlinRegOpt(h_fig,h_fig2);

% display action
setContPan('Correction factors were successfully calculated!','success',...
    h_fig);


