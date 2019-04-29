function popupmenu_TP_states_indexThresh_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    ud_DTA(h.figure_MASH);
end