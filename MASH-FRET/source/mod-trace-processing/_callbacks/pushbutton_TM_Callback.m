function pushbutton_TM_Callback(obj, evd, h_fig)

% adjust current project index in case it is out of list range (can happen 
% when project import failed)
setcurrproj(h_fig);

% display process
setContPan('Opening Trace manager...','process',h_fig);

traceManager(h_fig);

% displaysuccess
setContPan('Trace manager is ready!','success',h_fig);