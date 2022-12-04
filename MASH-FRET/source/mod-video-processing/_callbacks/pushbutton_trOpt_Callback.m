function pushbutton_trOpt_Callback(obj, evd, h_fig)

h = guidata(h_fig);

if isfield(h, 'figure_trsfOpt') && ishandle(h.figure_trsfOpt)
    return
end

% display process
setContPan('Open import options window...','process',h_fig);

buildTrsfOpt(h_fig);

% display success
setContPan('Import options window is ready!','success',h_fig);




