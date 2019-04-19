function edit_TDPfit_res_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'TDP');
end