function pushbutton_calcTfr_Callback(obj, evd, h)
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    tform_type = h.param.movPr.trsf_type;
    if isfield(h.param.movPr, 'trsf_coordRef') && ...
            ~isempty(h.param.movPr.trsf_coordRef)
        if tform_type > 1
            tr = createTrafo(tform_type, h.param.movPr.trsf_coordRef);
            if isempty(tr)
                updateActPan('Unable to calculate transformations.', ...
                    h.figure_MASH, 'error');
                return;
            end

            h.param.movPr.trsf_tr = tr;
            guidata(h.figure_MASH, h);

            saved = 0;
            
            if isfield(h.param.movPr, 'trsf_coordRef_file') && ...
                    ~isempty(h.param.movPr.trsf_coordRef_file)
                [o,fname,o] = fileparts(h.param.movPr.trsf_coordRef_file);
            else
                fname = 'transformation';
            end
            defName = [setCorrectPath('transformed', h.figure_MASH) ...
                fname '.mat'];
            [fname,pname,o] = uiputfile({ ...
                '*.mat', 'Matlab files(*.mat)'; ...
                '*.*', 'All files(*.*)'}, 'Export transformation', ...
                defName);

            str_type = get(h.popupmenu_trType, 'String');
            str_type = str_type{tform_type};

            if ~isempty(fname) && sum(fname)
                cd(pname);
                [o,fname,o] = fileparts(fname);
                fname_tr = getCorrName([fname '_trs.mat'], pname, ...
                    h.figure_MASH);
                if ~isempty(fname_tr) && sum(fname_tr)
                    save([pname fname_tr], '-mat', 'tr' );
                    h.param.movPr.trsf_tr_file = fname_tr;
                    guidata(h.figure_MASH, h);

                    updateActPan(['Transformation matrices calculated ' ...
                        'from type "' str_type '" are loaded and have ' ...
                        'been saved to file: ' fname_tr ...
                        '\n in folder: ' pname], h.figure_MASH, 'success');
                    saved = 1;
                end
            end
            if ~saved
                h.param.movPr.trsf_tr_file = [];
                guidata(h.figure_MASH, h);
                updateActPan( ['Transformations matrices calculated ' ...
                    'from type "' str_type '" loaded but not saved.'], ...
                    h.figure_MASH, 'process');
            end
            updateFields(h.figure_MASH, 'movPr');
        else
            updateActPan('Select a transformation type.', ...
                h.figure_MASH, 'error');
        end
    else
        updateActPan('No reference coordinates loaded.', ...
            h.figure_MASH, 'error');
    end

else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h.figure_MASH, 'error');
end