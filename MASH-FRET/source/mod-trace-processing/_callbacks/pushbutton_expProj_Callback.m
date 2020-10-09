function pushbutton_expProj_Callback(obj, evd, h_fig)

%% Last update: 25.4.2019 by MH
% >> save current project tage names and colors in interface's default 
%    parameters (default_param.ini)
%
% update: 2.4.2019 by MH
% >> update current project parameters with saved project parameters: this
%    mimic the subsequent load of saved project and closing of previous one
%
% update: 29.3.2019 by MH
% >> adapt reorganization of cross-talk coefficients to new parameter 
%    structure (see project/setDefPrm_traces.m)
%%

h = guidata(h_fig);
p = h.param.ttPr;

% added by MH, 24.4.2019
pMov = h.param.movPr;

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
            h_fig);
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
        fname_proj = getCorrName([fname '.mash'], pname,h_fig);
        
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
            figname = get(h_fig, 'Name');
            a = strfind(figname, 'MASH-FRET ');
            b = a + numel('MASH-FRET ');
            vers = figname(b:end);
            dat.MASH_version = vers;
            
            % save project data to file
            save([pname fname_proj], '-struct', 'dat');
            updateActPan(['Project has been successfully saved to file: ' ...
                pname fname_proj], h_fig, 'success');
            
            % set interface default param. to project's default param.
            p.defProjPrm = p.proj{proj}.def;
            
            % save current project's cross-talks as default
            p.defProjPrm.general{4} = p.proj{proj}.fix{4};
            
            % added by MH, 24.4.2019
            pMov.defTagNames = p.proj{proj}.molTagNames;
            pMov.defTagClr = p.proj{proj}.molTagClr;
            
            chanExc = p.proj{proj}.chanExc;
            exc = p.proj{proj}.excitations;
            
            % removed by MH, 29.3.2019
%             % reorder the cross talk coefficients as the wavelength
%             [o,id] = sort(p.proj{proj}.excitations,'ascend'); % chronological index sorted as wl

            % modified by MH, 13.1.2020
%             mol_prev = p.defProjPrm.mol{5};
            cf_bywl = p.defProjPrm.general{4}{2};
            
            if size(cf_bywl,1)>0
                % modified by MH, 29.3.2019
    %             for c = 1:dat.nb_channel
    %                 p.defProjPrm.mol{5}{1}(:,c) = mol_prev{1}(id,c);
    %                 p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
    %             end
                for c = 1:dat.nb_channel
                    if sum(exc==chanExc(c)) % emitter-specific illumination 
                                            % defined and present in used ALEX 
                                            % scheme (DE calculation possible)
                        % reorder the direct excitation coefficients according 
                        % to laser wavelength
                        exc_but_c = exc(exc~=chanExc(c));
                        if isempty(exc_but_c)
                            continue
                        end
                        [o,id] = sort(exc_but_c,'ascend'); % chronological index sorted as wl

                        % modified by MH, 13.1.2020
    %                     p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
                        p.defProjPrm.general{4}{2}(:,c) = cf_bywl(id,c);
                    end
                end
            end
            
            % added by MH, 4.2.2019
            p.proj{proj}.cnt_p_sec = dat.cnt_p_sec;
            p.proj{proj}.cnt_p_pix = dat.cnt_p_pix;
            p.proj{proj}.date_last_modif = dat.date_last_modif;
            
            % update exported file path to current project
            p.proj{proj}.proj_file = dat.proj_file;
            h.param.ttPr = p;
            
            % added by MH, 24.4.2019
            h.param.movPr = pMov;
            
            guidata(h_fig,h);
        end
    end
end
