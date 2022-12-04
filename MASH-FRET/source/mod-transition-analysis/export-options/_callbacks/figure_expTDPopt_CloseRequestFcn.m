function figure_expTDPopt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'expTDPopt')
    q = guidata(h.expTDPopt.figure_expTDPopt);
    h.param.proj{h.param.curr_proj}.TA.exp = q;
    h = rmfield(h, 'expTDPopt');
    guidata(h_fig, h);
end
delete(obj);