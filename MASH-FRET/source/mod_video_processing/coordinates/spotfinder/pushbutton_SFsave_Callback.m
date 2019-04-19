function pushbutton_SFsave_Callback(obj, evd, h)
h = guidata(h.figure_MASH);
p = h.param.movPr;

if ~isempty(h.param.movPr.SFres)
    if p.SF_method > 1
        updateFields(h.figure_MASH, 'movPr');
        [coord pname fname] = saveSpots(h.figure_MASH);
        if ~isempty(coord)
            p.coordMol = coord(:,1:2);
            if ~isempty(fname) && sum(fname)
                p.coordMol_file = [fname '.spots'];
                updateActPan(['Spots coordinates have been successfully'...
                    ' written to file: ' fname '.spots\nin folder: '...
                    pname], h.figure_MASH, 'success');
            else
                updateActPan('Spots coordinates loaded but not saved', ...
                    h.figure_MASH, 'process');
                p.coordMol_file = [];
                pname = [];
            end

            if p.nChan == 1 && isempty(p.coordItg)
                p.coordItg = p.coordMol(:,1:2);
                p.coordItg_file = p.coordMol_file;
                p.itg_coordFullPth = [pname p.coordMol_file];

            elseif p.nChan > 1 && isempty(p.coordTrsf)
                p.coordTrsf = p.coordMol(:,1:2);
                p.coordTrsf_file = p.coordMol_file;
            end
            h.param.movPr = p;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'movPr');
        end
    end
else
    updateActPan('Start a "spotfinder" procedure first.', h.figure_MASH,...
        'error');
end
