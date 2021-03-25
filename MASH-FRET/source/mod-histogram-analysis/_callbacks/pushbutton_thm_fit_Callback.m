function pushbutton_thm_fit_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h_fig, 'thm');
    gauss_ana(h_fig);
    updateFields(h_fig, 'thm');
end