function pushbutton_thm_export_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    export_thm(h.figure_MASH);
end