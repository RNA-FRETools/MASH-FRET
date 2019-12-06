function pushbutton_calcTfr_Callback(obj, evd, h_fig)
h = guidata(h_fig);
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    tform_type = h.param.movPr.trsf_type;
    if isfield(h.param.movPr, 'trsf_coordRef') && ...
            ~isempty(h.param.movPr.trsf_coordRef)
        if tform_type > 1
            tr = createTrafo(tform_type, h.param.movPr.trsf_coordRef,...
                h_fig);
            if isempty(tr)
                return;
            end

            h.param.movPr.trsf_tr = tr;
            guidata(h_fig, h);

            saved = 0;
            
            if isfield(h.param.movPr, 'trsf_coordRef_file') && ...
                    ~isempty(h.param.movPr.trsf_coordRef_file)
                [o,fname,o] = fileparts(h.param.movPr.trsf_coordRef_file);
            else
                fname = 'transformation';
            end
            defName = [setCorrectPath('transformed', h_fig) ...
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
                    h_fig);
                if ~isempty(fname_tr) && sum(fname_tr)
                    save([pname fname_tr], '-mat', 'tr' );
                    h.param.movPr.trsf_tr_file = fname_tr;
                    guidata(h_fig, h);

                    updateActPan(['Transformation matrices calculated ' ...
                        'from type "' str_type '" are loaded and have ' ...
                        'been saved to file: ' fname_tr ...
                        '\n in folder: ' pname], h_fig, 'success');
                    saved = 1;
                end
            end
            if ~saved
                h.param.movPr.trsf_tr_file = [];
                guidata(h_fig, h);
                updateActPan( ['Transformations matrices calculated ' ...
                    'from type "' str_type '" loaded but not saved.'], ...
                    h_fig, 'process');
            end
            updateFields(h_fig, 'movPr');
        else
            updateActPan('Select a transformation type.', ...
                h_fig, 'error');
        end
    else
        updateActPan('No reference coordinates loaded.', ...
            h_fig, 'error');
    end

else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h_fig, 'error');
end