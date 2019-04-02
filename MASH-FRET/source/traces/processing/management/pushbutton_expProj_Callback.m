function pushbutton_expProj_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj);
    
    % collect current project
    proj = p.curr_proj;
    
    % get file name
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
        
        % change to directory for easier user re-access
        cd(pname);
        
        % correct file name if necessary
        [o,fname,o] = fileparts(fname);
        fname_proj = getCorrName([fname '.mash'], pname,h.figure_MASH);
        
        if ~isempty(fname_proj) && sum(fname_proj)
            
            % collect project data
            dat = p.proj{proj};
            dat = rmfield(dat, {'prm', 'exp'});
            dat.prmTT = p.proj{proj}.prm;
            dat.expTT = p.proj{proj}.exp;
            dat.cnt_p_sec = p.proj{proj}.fix{2}(4);
            dat.cnt_p_pix = p.proj{proj}.fix{2}(5);
            dat.proj_file = [pname fname_proj];
            dat.date_last_modif = datestr(now);
            
            % set MASH-FRET version
            figname = get(h.figure_MASH, 'Name');
            a = strfind(figname, 'MASH-FRET ');
            b = a + numel('MASH-FRET ');
            vers = figname(b:end);
            dat.MASH_version = vers;
            
            % save project data to file
            save([pname fname_proj], '-struct', 'dat');
            updateActPan(['Project has been successfully saved to file: ' ...
                pname fname_proj], h.figure_MASH, 'success');
            
            % set interface default param. to project's default param.
            p.defProjPrm = p.proj{proj}.def;
            
            % reorder the cross talk coefficients as the wavelength
            [o,id] = sort(p.proj{proj}.excitations,'ascend'); % chronological index sorted as wl
            mol_prev = p.defProjPrm.mol{5};
            for c = 1:dat.nb_channel
                p.defProjPrm.mol{5}{1}(:,c) = mol_prev{1}(id,c);
                p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
            end
            
            % update exported file path to current project
            p.proj{proj}.proj_file = dat.proj_file;
            h.param.ttPr = p;
            guidata(h.figure_MASH,h);
        end
    end
end