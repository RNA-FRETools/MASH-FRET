function ud_SFspots(h_fig)
h = guidata(h_fig);

% Set fields to proper values
updateFields(h.figure_MASH, 'movPr');

if isfield(h, 'movie') && isfield(h.param.movPr, 'SFres') && ...
        ~isempty(h.param.movPr.SFres)

    % Delete exclusion rules
    oldRes = h.param.movPr.SFres;
    h.param.movPr.SFres = {};
    for i = 1:size(oldRes,2)
        h.param.movPr.SFres{1,i} = oldRes{1,i};
    end
    guidata(h_fig);
    
    % Apply exclusion rules and display results
    updateImgAxes(h_fig);
end