function pushbutton_trLoad_Callback(obj, evd, h)
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    [fname, pname, o] = uigetfile({'*.mat','Matlab files(*.mat)'; ...
        '*.*',  'All Files (*.*)'}, 'Select a transformation file:', ...
        setCorrectPath('transformed', h.figure_MASH));

    if ~isempty(fname) && sum(fname)
        cd(pname);
        [o, o, fExt] = fileparts(fname);
        if ~strcmp(fExt, '.mat')
            updateActPan('Wrong file format.', h.figure_MASH, 'error');
            return;
        end

        TFORM = open([pname fname]);
        if isfield(TFORM, 'tr') && ~isempty(TFORM.tr)
            tr = TFORM.tr;
        else
            updateActPan('Unable to load transformations.', ...
                h.figure_MASH, 'error');
            return;
        end

        updateActPan(['Spatial transformations have been ' ...
            'successfully loaded from file: ' fname '\nin folder: ' ...
            pname], ...
            h.figure_MASH, 'success');
        h.param.movPr.trsf_tr = tr;
        h.param.movPr.trsf_tr_file = fname;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'movPr');
    end

else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h.figure_MASH, 'error');
end