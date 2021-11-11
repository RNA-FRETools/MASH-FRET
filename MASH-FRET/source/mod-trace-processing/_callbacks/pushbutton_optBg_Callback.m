function pushbutton_optBg_Callback(obj, evd, h_fig)

% show process
setContPan('Opening Background analyzer...','process',h_fig);

backgroundAnalyser(h_fig);

% show success
setContPan('Background analyzer ready!','success',h_fig);