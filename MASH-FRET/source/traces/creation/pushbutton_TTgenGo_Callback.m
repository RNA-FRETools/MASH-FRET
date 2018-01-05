function pushbutton_TTgenGo_Callback(obj, evd, h)
updateFields(h.figure_MASH, 'movPr');
if isfield(h.param.movPr, 'itg_movFullPth') && ...
        ~isempty(h.param.movPr.itg_movFullPth)
    
    if isfield(h.param.movPr, 'coordItg') && ...
            ~isempty(h.param.movPr.coordItg)
        [o,movName,o] = fileparts(h.param.movPr.itg_movFullPth);
        defName = [h.folderRoot filesep movName '.mash'];
        [fname,pname,o] = uiputfile(...
            {'*.mash;', 'MASH project(*.mash)'; ...
             '*.*', 'All Files (*.*)'}, 'Export MASH project', defName);

        if ~isempty(fname) && sum(fname)
            cd(pname);
            [o,fname,o] = fileparts(fname);
            fname_proj = getCorrName([fname '.mash'], pname, ...
                h.figure_MASH);
            if ~isempty(fname_proj) && sum(fname_proj)
                dat = exportProject(h.param.movPr, [pname fname_proj], ...
                    h.figure_MASH);
                if ~isempty(dat)
                    save([pname fname_proj], '-struct', 'dat');
                    saveTraces(dat, pname, fname_proj, ...
                        {h.param.movPr.itg_expMolFile ...
                        h.param.movPr.itg_expFRET}, h.figure_MASH);
                end
            end
        end
        
    else
        set(h.edit_itg_coordFile, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('No coordinates loaded.', h.figure_MASH, 'error');
    end
else
    set(h.edit_movItg, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('No movie loaded.', h.figure_MASH, 'error');
end
