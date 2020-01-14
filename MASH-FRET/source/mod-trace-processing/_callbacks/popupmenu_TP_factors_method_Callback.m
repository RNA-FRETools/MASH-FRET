% MH modified checkbox to popupmenu 26.3.2019
% FS added 8.1.2018, last modified 11.1.2018
function popupmenu_TP_factors_method_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    method = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    fret = p.proj{proj}.fix{3}(8);
    p.proj{proj}.curr{mol}{6}{2}(fret) = method-1; % method
    h.param.ttPr = p;
    guidata(h_fig, h);
    ud_factors(h_fig)
end
