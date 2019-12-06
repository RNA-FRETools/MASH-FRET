function pushbutton_trGo_Callback(obj, evd, h_fig)
h = guidata(h_fig);
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3

    if isfield(h.param.movPr, 'trsf_tr') && ...
            ~isempty(h.param.movPr.trsf_tr) && ...
            isfield(h.param.movPr, 'coordMol') && ...
            ~isempty(h.param.movPr.coordMol)

        q.res_x = h.param.movPr.trsf_coordLim(1);
        q.res_y = h.param.movPr.trsf_coordLim(2);
        q.nChan = h.param.movPr.nChan;
        q.spotSize = h.param.movPr.SF_w;
        q.spotDmin = h.param.movPr.SF_minDspot;
        q.edgeDmin = h.param.movPr.SF_minDedge;

        coordTrsf = applyTrafo(h.param.movPr.trsf_tr, ...
            h.param.movPr.coordMol, q, h_fig);
        if isempty(coordTrsf)
            return;
        end

        h.param.movPr.coordTrsf = coordTrsf;
        h.param.movPr.SFres = {};
        
        guidata(h_fig, h);
        nC = h.param.movPr.nChan;

        updateFields(h_fig, 'imgAxes');
        h = guidata(h_fig);

        saved = 0;
        if ~isempty(h.param.movPr.coordMol_file)
            [o, fname, o] = fileparts(h.param.movPr.coordMol_file);
        else
            fname = 'transformed_coordinates';
        end
        defName = [setCorrectPath('transformed', h_fig) fname ...
            '.coord'];
        [fname,pname,o] = uiputfile({...
            '*.coord', 'Transformed coordinates files(*.coord)'; ...
            '*.*', 'All files(*.*)'}, ...
            'Export transformation', defName);

        if ~isempty(fname) && sum(fname)
            cd(pname);
            [o,fname,o] = fileparts(fname);
            fname = getCorrName([fname '.coord'], pname, h_fig);
            if ~isempty(fname) && sum(fname)

                str_header = 'x1\ty1'; str_fmt = '%d\t%d';
                for i = 2:nC
                    str_header = [str_header '\tx' num2str(i) '\ty' ...
                        num2str(i)];
                    str_fmt = [str_fmt '\t%d\t%d'];
                end
                str_header = [str_header '\n'];
                str_fmt = [str_fmt '\n'];

                f = fopen([pname fname], 'Wt');
                fprintf(f, str_header);
                fprintf(f, str_fmt, coordTrsf');
                fclose(f);

                h.param.movPr.coordTrsf_file = fname;
                guidata(h_fig, h);

                saved = 1;

                updateActPan(['Transformed coordinates have been saved' ...
                    ' to file: ' fname '\n in folder: ' pname], ...
                    h_fig, 'success');
            end
        end
        if ~saved
            h.param.movPr.coordTrsf_file = [];
            guidata(h_fig, h);
            updateActPan(['Transformed coordinates loaded but not ' ...
                'saved'], h_fig, 'process');
        end

        if nC == 1 && isempty(h.param.movPr.coordItg)
            h.param.movPr.coordItg_file = h.param.movPr.coordTrsf_file;
            h.param.movPr.itg_coordFullPth = [pname ...
                h.param.movPr.coordTrsf_file];
            h.param.movPr.coordItg = h.param.movPr.coordTrsf;
            guidata(h_fig, h);
        end
        updateFields(h_fig, 'movPr');
    else
        updateActPan('No input coordinates or transformation loaded.', ...
            h_fig, 'error');
    end
else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h_fig, 'error');
end