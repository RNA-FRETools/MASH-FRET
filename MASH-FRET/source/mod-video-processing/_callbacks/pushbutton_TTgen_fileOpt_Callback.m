function pushbutton_TTgen_fileOpt_Callback(obj,evd,h_fig)

% display process
setContPan('Open export options window...','process',h_fig);

if ~openItgFileOpt([],[],h_fig)
    return
end

% display success
setContPan('Export options window is ready!','success',h_fig);