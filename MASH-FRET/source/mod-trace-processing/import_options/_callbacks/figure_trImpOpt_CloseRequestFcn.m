function figure_trImpOpt_CloseRequestFcn(obj, evd, h_fig)

h = guidata(h_fig);
if isfield(h, 'trImpOpt');
    h = rmfield(h, {'trImpOpt', 'figure_trImpOpt'});
    guidata(h_fig, h);
end

delete(obj);
