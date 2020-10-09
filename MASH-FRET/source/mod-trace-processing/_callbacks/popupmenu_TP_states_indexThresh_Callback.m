function popupmenu_TP_states_indexThresh_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    ud_DTA(h_fig);
end