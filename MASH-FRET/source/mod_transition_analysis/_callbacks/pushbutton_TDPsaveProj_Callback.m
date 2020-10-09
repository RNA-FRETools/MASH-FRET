function pushbutton_TDPsaveProj_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj);
    proj = p.curr_proj;
    if ~isempty(p.proj{proj}.proj_file)
        projName = p.proj{proj}.proj_file;
    elseif ~isempty(p.proj{proj}.exp_parameters{1,2})
        projName = getCorrName([p.proj{proj}.exp_parameters{1,2} ...
            '.mash'], [], h_fig);
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
            h_fig);
        cd(pname);
        [o,fname,o] = fileparts(fname);
        fname_proj = getCorrName([fname '.mash'], pname, ...
            h_fig);
        if ~isempty(fname_proj) && sum(fname_proj)
            dat = p.proj{proj};
            dat = rmfield(dat, {'prm', 'exp'});
            dat.prmTDP = p.proj{proj}.prm;
            dat.expTDP = p.proj{proj}.exp;
            
            figname = get(h_fig, 'Name');
            a = strfind(figname, 'MASH-FRET ');
            b = a + numel('MASH-FRET ');
            vers = figname(b:end);
            dat.MASH_version = vers;
            
            dat.proj_file = [pname fname_proj];
            dat.date_last_modif = datestr(now);
            save([pname fname_proj], '-struct', 'dat');
            setContPan(['Project has been successfully saved to file: ' ...
                pname fname_proj], 'success' , h_fig);
            
            p.proj{proj}.proj_file = dat.proj_file;
            h.param.TDP = p;
            guidata(h_fig,h);
        end
    end
end