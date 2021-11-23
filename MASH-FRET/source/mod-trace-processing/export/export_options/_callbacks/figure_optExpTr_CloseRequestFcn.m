function figure_optExpTr_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'optExpTr')
    h = rmfield(h, 'optExpTr');
    guidata(h_fig, h);
end

delete(obj);