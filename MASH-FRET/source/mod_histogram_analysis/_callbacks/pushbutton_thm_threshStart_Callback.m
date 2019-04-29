function pushbutton_thm_threshStart_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
    thresh_ana(h.figure_MASH);
    updateFields(h.figure_MASH, 'thm');
end