function pushbutton_thm_saveProj_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj);
    proj = p.curr_proj;
    if ~isempty(p.proj{proj}.proj_file)
        projName = p.proj{proj}.proj_file;
    elseif ~isempty(p.proj{proj}.exp_parameters{1,2})
        projName = getCorrName([p.proj{proj}.exp_parameters{1,2} ...
            '.mash'], [], h.figure_MASH);
    else
        projName = 'project.mash';
    end
    [pName, projName,o] = fileparts(projName);
    defName = [pName filesep projName '.mash'];
    [fname,pname,o] = uiputfile(...
        {'*.mash;', 'MASH project(*.mash)'; ...
         '*.*', 'All Files (*.*)'}, 'Export MASH project', defName);

    if ~isempty(fname) && sum(fname)
        setContPan(['Save project ' fname ' ...'], 'process' , ...
            h.figure_MASH);
        cd(pname);
        [o,fname,o] = fileparts(fname);
        fname_proj = getCorrName([fname '.mash'], pname, ...
            h.figure_MASH);
        if ~isempty(fname_proj) && sum(fname_proj)
            dat = p.proj{proj};
            dat = rmfield(dat, {'prm', 'exp'});
            dat.prmThm = p.proj{proj}.prm;
            dat.expThm = p.proj{proj}.exp;
            
            figname = get(h.figure_MASH, 'Name');
            a = strfind(figname, 'MASH-FRET ');
            b = a + numel('MASH-FRET ');
            vers = figname(b:end);
            dat.MASH_version = vers;
            
            dat.proj_file = [pname fname_proj];
            dat.date_last_modif = datestr(now);
            save([pname fname_proj], '-struct', 'dat');
            setContPan(['Project has been successfully saved to file: ' ...
                pname fname_proj], 'success' , h.figure_MASH);
            
            p.proj{proj}.proj_file = dat.proj_file;
            h.param.thm = p;
            guidata(h.figure_MASH,h);
        end
    end
end