function pushbutton_SFsave_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.movPr;

if ~isempty(h.param.movPr.SFres)
    if p.SF_method > 1
        updateFields(h_fig, 'movPr');
        [coord pname fname] = saveSpots(h_fig);
        if ~isempty(coord)
            p.coordMol = coord(:,1:2);
            if ~isempty(fname) && sum(fname)
                p.coordMol_file = [fname '.spots'];
                updateActPan(['Spots coordinates have been successfully'...
                    ' written to file: ' fname '.spots\nin folder: '...
                    pname], h_fig, 'success');
            else
                updateActPan('Spots coordinates loaded but not saved', ...
                    h_fig, 'process');
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
            guidata(h_fig, h);
            updateFields(h_fig, 'movPr');
        end
    end
else
    updateActPan('Start a "spotfinder" procedure first.', h_fig,...
        'error');
end
