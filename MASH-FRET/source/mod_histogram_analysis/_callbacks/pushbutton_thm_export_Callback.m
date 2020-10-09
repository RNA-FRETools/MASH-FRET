function pushbutton_thm_export_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    export_thm(h_fig);
end