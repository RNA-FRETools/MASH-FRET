function popupmenu_thm_gaussNb_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
end