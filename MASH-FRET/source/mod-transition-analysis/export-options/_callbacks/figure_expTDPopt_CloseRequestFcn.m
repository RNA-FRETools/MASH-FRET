function figure_expTDPopt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'expTDPopt')
    q = guidata(h.expTDPopt.figure_expTDPopt);
    proj = h.param.TDP.curr_proj;
    h.param.TDP.proj{proj}.exp = q;
    h = rmfield(h, 'expTDPopt');
    guidata(h_fig, h);
end
delete(obj);