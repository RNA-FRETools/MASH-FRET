function pushbutton_TA_export_Callback(obj,evd,h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% show process
setContPan('Open export options...','process',h_fig);

expTDPopt(h_fig);

% show success
setContPan('Export options ready!','success',h_fig);