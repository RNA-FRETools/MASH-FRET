function pushbutton_trLoadRef_Callback(obj, evd, h)
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    [fname, pname, o] = uigetfile(...
        {'*.map;*.cpSelect','Coordinates File(*.map;*.cpSelect)'; ...
         '*.*',  'All Files (*.*)'}, ...
         'Pick a co-localised coordinates file', ...
         setCorrectPath('mapping', h.figure_MASH));

    if ~isempty(fname) && sum(fname)
        cd(pname);
        fDat = importdata([pname fname], '\n');
        if isstruct(fDat)
            fDat = fDat.Sheet1;
        end
        res_x = h.param.movPr.trsf_coordLim(1);
        mode = h.param.movPr.trsf_refImp_mode;
        switch mode
            case 'rw'
                p = h.param.movPr.trsf_refImp_rw;
            case 'cw'
                p = h.param.movPr.trsf_refImp_cw;
        end
        coord_ref = orgCoordCol(fDat, mode, p, h.param.movPr.nChan, res_x, ...
            h.figure_MASH);
        
        if isempty(coord_ref) || ...
                size(coord_ref, 2) ~= 2*h.param.movPr.nChan
            return;
        end

        updateActPan(['Reference coordinates successfully loaded from ' ...
            'file: ' fname '\nin folder: ' pname], h.figure_MASH);
        h.param.movPr.trsf_coordRef = coord_ref;
        h.param.movPr.trsf_coordRef_file = fname;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'movPr');

    end

else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h.figure_MASH, 'error');
end