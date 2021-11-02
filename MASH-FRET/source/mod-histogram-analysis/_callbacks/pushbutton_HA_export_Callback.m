function pushbutton_HA_export_Callback(obj, evd, h_fig)
% pushbutton_HA_export_Callback([],[],h_fig)
% pushbutton_HA_export_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

if iscell(obj)
    export_thm(h_fig,obj);
else
    export_thm(h_fig);
end

