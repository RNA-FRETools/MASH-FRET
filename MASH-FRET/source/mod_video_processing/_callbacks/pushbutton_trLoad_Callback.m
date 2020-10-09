function pushbutton_trLoad_Callback(obj, evd, h_fig)
h = guidata(h_fig);
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    [fname, pname, o] = uigetfile({'*.mat','Matlab files(*.mat)'; ...
        '*.*',  'All Files (*.*)'}, 'Select a transformation file:', ...
        setCorrectPath('transformed', h_fig));

    if ~isempty(fname) && sum(fname)
        cd(pname);
        [o, o, fExt] = fileparts(fname);
        if ~strcmp(fExt, '.mat')
            updateActPan('Wrong file format.', h_fig, 'error');
            return;
        end

        TFORM = open([pname fname]);
        if isfield(TFORM, 'tr') && ~isempty(TFORM.tr)
            tr = TFORM.tr;
        else
            updateActPan('Unable to load transformations.', ...
                h_fig, 'error');
            return;
        end

        updateActPan(['Spatial transformations have been ' ...
            'successfully loaded from file: ' fname '\nin folder: ' ...
            pname], ...
            h_fig, 'success');
        h.param.movPr.trsf_tr = tr;
        h.param.movPr.trsf_tr_file = fname;
        guidata(h_fig, h);
        updateFields(h_fig, 'movPr');
    end

else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h_fig, 'error');
end