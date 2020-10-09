function pushbutton_trLoadRef_Callback(obj, evd, h_fig)
h = guidata(h_fig);
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    [fname, pname, o] = uigetfile(...
        {'*.map;*.cpSelect','Coordinates File(*.map;*.cpSelect)'; ...
         '*.*',  'All Files (*.*)'}, ...
         'Pick a co-localised coordinates file', ...
         setCorrectPath('mapping', h_fig));

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
            h_fig);
        
        if isempty(coord_ref) || ...
                size(coord_ref, 2) ~= 2*h.param.movPr.nChan
            return;
        end

        updateActPan(['Reference coordinates successfully loaded from ' ...
            'file: ' fname '\nin folder: ' pname], h_fig);
        h.param.movPr.trsf_coordRef = coord_ref;
        h.param.movPr.trsf_coordRef_file = fname;
        guidata(h_fig, h);
        updateFields(h_fig, 'movPr');

    end

else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h_fig, 'error');
end