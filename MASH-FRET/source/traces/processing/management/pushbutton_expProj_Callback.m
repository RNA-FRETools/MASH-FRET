function pushbutton_expProj_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj);
    proj = p.curr_proj;
    if ~isempty(p.proj{proj}.proj_file)
        projName = p.proj{proj}.proj_file;
        [pName,projName,o] = fileparts(projName);
        
    elseif ~isempty(p.proj{proj}.exp_parameters{1,2})
        pName = pwd;
        projName = getCorrName(p.proj{proj}.exp_parameters{1,2}, [], ...
            h.figure_MASH);
    else
        pName = pwd;
        projName = 'project';
    end
    defName = [pName filesep projName '.mash'];
    [fname,pname,o] = uiputfile(...
        {'*.mash;', 'MASH project(*.mash)'; ...
         '*.*', 'All Files (*.*)'}, 'Export MASH project', defName);

    if ~isempty(fname) && sum(fname)
        cd(pname);
        [o,fname,o] = fileparts(fname);
        fname_proj = getCorrName([fname '.mash'], pname, ...
            h.figure_MASH);
        if ~isempty(fname_proj) && sum(fname_proj)
            dat = p.proj{proj};
            dat = rmfield(dat, {'prm', 'exp'});
            dat.prmTT = p.proj{proj}.prm;
            dat.expTT = p.proj{proj}.exp;
            dat.cnt_p_sec = dat.fix{2}(4);
            dat.cnt_p_pix = dat.fix{2}(5);
            
            p.defProjPrm = dat.def;
            
            % reorder the cross talk coefficients as the wavelength
            [o,id] = sort(dat.excitations,'ascend'); % chronological index sorted as wl
            mol_prev = p.defProjPrm.mol{5};
            for c = 1:dat.nb_channel
                p.defProjPrm.mol{5}{1}(:,c) = mol_prev{1}(id,c);
                p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
            end
            
            h.param.ttPr = p;
            guidata(h.figure_MASH,h);
            
            figname = get(h.figure_MASH, 'Name');
            a = strfind(figname, 'MASH smFRET ');
            b = a + numel('MASH smFRET ');
            vers = figname(b:end);
            dat.MASH_version = vers;
            
            dat.proj_file = [pname fname_proj];
            dat.date_last_modif = datestr(now);
            save([pname fname_proj], '-struct', 'dat');
            updateActPan(['Project ' fname ' has been successfully ' ...
                'exported to folder: ' pname], h.figure_MASH, 'success');
        end
    end
end