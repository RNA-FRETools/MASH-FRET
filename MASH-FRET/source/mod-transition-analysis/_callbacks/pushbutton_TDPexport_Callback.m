function pushbutton_TDPexport_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    expTDPopt(h_fig);
end