function pushbutton_addTraces_Callback(obj, evd, h)

%%
% Last update: 29.3.2019 by MH
% >> manage down-compatibility and adapt reorganization of cross-talk 
%    coefficients to new parameter structure (see 
%    project/setDefPrm_traces.m)
% >> cancel saving of ASCII-improted gamma factors in p.proj{i}.prm: if
%    save in prm, molecule won't be processed with new gammas
%
% Last update: 28.3.2019 by MH
% --> For ASCII traces import: gamma factors files are recovered from 
%     import options
%
% update: 28.3.2018 by FS
% --> if ASCII file and not MASH project is loaded: load gamma factor file
%     if it exists; assign gamma value only if number of values in .gam 
%     file equals the number of loaded restructured ASCII files
%%

% collect files to import
defPth = h.folderRoot;
[fname,pname,o] = uigetfile({'*.mash', 'MASH project(*.mash)'; '*.*', ...
    'All files(*.*)'}, 'Select trace files', defPth, 'MultiSelect', 'on');

if ~isempty(fname) && ~isempty(pname) && sum(pname)
    
    % covert to cell if only one file is imported
    if ~iscell(fname)
        fname = {fname};
    end
    
    p = h.param.ttPr;
    
    % check if the project file is not already loaded
    excl_f = false(size(fname));
    str_proj = get(h.listbox_traceSet,'string');
    if isfield(p,'proj')
        for i = 1:numel(fname)
            for j = 1:numel(p.proj)
                if strcmp(cat(2,pname,fname{i}),p.proj{j}.proj_file)
                    excl_f(i) = true;
                    disp(cat(2,'project "',str_proj{j},'" is already ',...
                        'opened (',p.proj{j}.proj_file,').'));
                end
            end
        end
    end
    fname(excl_f) = [];
    
    % stop if no file is left
    if isempty(fname)
        return;
    end
    
    % load project data
    [dat,ok] = loadProj(pname, fname, 'intensities', h.figure_MASH);
    if ~ok
        return;
    end
    p.proj = [p.proj dat];
    
    % load gamma factor file if it exists; added by FS, 28.3.2018
    [o,o,fext] = fileparts(fname{1});
    if ~strcmp(fext, '.mash') % if ASCII file and not MASH project is loaded
        
        % cancelled by MH, 28.3.2019
%         [fnameGamma,pnameGamma,~] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
%                 'All files(*.*)'}, 'Select gamma factor file', defPth, 'MultiSelect', 'on');

        % collect gamma files from import options, added by MH, 28.3.2019
        pnameGamma = p.impPrm{6}{2};
        fnameGamma = p.impPrm{6}{3};
        
        if ~isempty(fnameGamma) && ~isempty(pnameGamma) && sum(pnameGamma)
            
            % cancelled by MH, 28.3.2019
%             if ~iscell(fnameGamma)
%                 fnameGamma = {fnameGamma};
%             end

            gammasCell = cell(1,length(fnameGamma));
            for f = 1:length(fnameGamma)
                filename = [pnameGamma fnameGamma{f}];
                fileID = fopen(filename,'r');
                formatSpec = '%f';
                gammasCell{f} = fscanf(fileID,formatSpec);
            end
            gammas = cell2mat(gammasCell');
        end
    end

    % define molecule processing parameters applied (prm) and to apply
    % (curr)
    for i = (size(p.proj,2)-size(dat,2)+1):size(p.proj,2)
        
        % moved here by MH, 29.3.2019
        nMol = numel(p.proj{i}.coord_incl);
        nChan = p.proj{i}.nb_channel;
        nExc = p.proj{i}.nb_excitations;
        
        % added by NH,29.3.2019
        exc = p.proj{i}.excitations;
        chanExc = p.proj{i}.chanExc;
        
        p.curr_mol(i) = 1;
        p.defProjPrm = setDefPrm_traces(p,i);

        p.proj{i}.fix = p.defProjPrm.general;
        p.proj{i}.def = p.defProjPrm;

        % cancelled by MH, 29.3.2019
%         % reorder the cross talk coefficients chronologically
%         [o,id] = sort(p.proj{i}.excitations,'ascend'); % chronological index sorted as wl

        mol_prev = p.proj{i}.def.mol{5};
        
        % modified by MH, 29.3.2019
%         for c = 1:p.proj{i}.nb_channel
%             p.proj{i}.def.mol{5}{1}(id,c) = mol_prev{1}(:,c);
%             p.proj{i}.def.mol{5}{2}(id,c) = mol_prev{2}(:,c);
%         end
        for c = 1:nChan
            if sum(exc==chanExc(c)) % emitter-specific illumination defined 
                                    % and present in used ALEX scheme (DE 
                                    % calculation possible)
                % reorder the direct excitation coefficients according to 
                % laser chronological order
                exc_but_c = exc(exc~=chanExc(c));
                [o,id] = sort(exc_but_c,'ascend'); % chronological index sorted as wl
                p.proj{i}.def.mol{5}{2}(id,c) = mol_prev{2}(:,c);
            end
        end

        if ~isfield(p.proj{i}, 'expTT')
            p.proj{i}.exp = [];
        else
            p.proj{i}.exp = p.proj{i}.expTT;
            p.proj{i} = rmfield(p.proj{i}, 'expTT');
        end
        p.proj{i}.exp = setExpOpt(p.proj{i}.exp, p.proj{i});
        
        if ~isfield(p.proj{i}, 'prmTT')
            p.proj{i}.prm = cell(1,nMol); % empty param. for all mol.
        else
            p.proj{i}.prm = p.proj{i}.prmTT;
            p.proj{i} = rmfield(p.proj{i}, 'prmTT');
        end
        
        % added by FS, 28.3.2018
        if ~strcmp(fext, '.mash')
            if ~isempty(fnameGamma) && ~isempty(pnameGamma) && sum(pnameGamma)
                if length(gammas) ~= nMol
                    updateActPan('number of gamma factors does not match the number of ASCII files loaded. Set all gamma factors to 1.', h.figure_MASH, 'error');
                    fnameGamma = []; % set to empty (will not try to import any gamma factors from file)
                end    
            end
        end
        
        for n = 1:nMol % set current param. for all mol.
            if n > size(p.proj{i}.prm,2)
                p.proj{i}.prm{n} = {};
            end
            
            % added by MH, 29.3.2019
            % reorder already-existing Bt coefficient values into new 
            % format: sum Bt coefficients over the different excitations 
            % and use as only Bt coefficients.
            if size(p.proj{i}.prm{n},2)>=5 && ...
                    size(p.proj{i}.prm{n}{5},2)>=2 && ...
                    iscell(p.proj{i}.prm{n}{5}{1})
                newBtPrm = zeros(nChan,nChan-1);
                for c = 1:nChan
                    bts = zeros(nExc,nChan-1);
                    for l = 1:nExc
                        bts(l,:) = p.proj{i}.prm{n}{5}{1}{l,c};
                    end
                    newBtPrm(c,:) = sum(bts,1);
                end
                p.proj{i}.prm{n}{5}{1} = newBtPrm;
            end
            
            % added by MH, 29.3.2019
            % reorder already-existing DE coefficient values into new 
            % format: use the first non-zero DE coefficient as only DE
            % coefficient.
            if size(p.proj{i}.prm{n},2)>=5 && ...
                    size(p.proj{i}.prm{n}{5},2)>=2 && ...
                    iscell(p.proj{i}.prm{n}{5}{2})
                newDePrm = zeros(nExc-1,nChan);
                for c = 1:nChan
                    l0 = find(exc==chanExc(c));
                    if isempty(l0)
                        newDePrm(:,c) = 0;
                        continue;
                    end

                    l0 = l0(1);
                    exc_dir = 0;
                    for l = 1:nExc
                        if l ~= l0
                            exc_dir = exc_dir+1;
                            val = find(p.proj{i}.prm{n}{5}{2}{l,c}~=0);
                            if isempty(val)
                                newDePrm(exc_dir,c) = 0;
                            else
                                newDePrm(exc_dir,c) = ...
                                    p.proj{i}.prm{n}{5}{2}{l,c}(val(1));
                            end
                        end
                    end
                end
                p.proj{i}.prm{n}{5}{2} = newDePrm;
            end
            
            % reshape old and already-applied "find states" parameters to 
            % new format
            if size(p.proj{i}.prm{n},2)>=4 && ...
                    size(p.proj{i}.prm{n}{4},2)>=2 && ...
                    size(p.proj{i}.prm{n}{4}{2},2)==8
                for j = 1:size(p.proj{i}.prm{n}{4}{2},3)
                    p.proj{i}.prm{n}{4}{2}(1,1:6,j) = ...
                        p.proj{i}.prm{n}{4}{2}(1,[2,1,5,8,3,4],j);
                    p.proj{i}.prm{n}{4}{2}(2,1:6,j) = ...
                        p.proj{i}.prm{n}{4}{2}(2,[1,2,5,8,3,4],j);
                    p.proj{i}.prm{n}{4}{2}(3,1:6,j) = ...
                        p.proj{i}.prm{n}{4}{2}(3,[1,2,5,8,3,4],j);
                    p.proj{i}.prm{n}{4}{2}(4,1:6,j) = ...
                        p.proj{i}.prm{n}{4}{2}(4,[5,6,7,8,3,4],j);
                    p.proj{i}.prm{n}{4}{2}(5,1:6,j) = ...
                        p.proj{i}.prm{n}{4}{2}(5,[2,1,5,8,3,4],j);
                end
                p.proj{i}.prm{n}{4}{2} = p.proj{i}.prm{n}{4}{2}(:,1:6,:);
            end

            p.proj{i}.curr{n} = adjustVal(p.proj{i}.prm{n}, ...
                p.proj{i}.def.mol);
            
            % added by FS, 28.3.2018
            % assign gamma value (assignment only works if number of values in .gam file equals the number of loaded restructured ASCII files)
            if ~strcmp(fext, '.mash') % if ASCII file and not MASH project is loaded
                if ~isempty(fnameGamma) && ~isempty(pnameGamma) && sum(pnameGamma)
                    % set the gamma factor from the .gam file 
                    % (FRET is calculated on the spot based on imported and corrected
                    % intensities)
                    p.proj{i}.curr{n}{5}{3} = gammas(n);
                    
                    % cancelled by MH, 29.3.2019
%                     p.proj{i}.prm{n}{5}{3} = gammas(n);

                end
                if ~isempty(fnameGamma) && ~isempty(pnameGamma)
                    % Cross talk and filter corrections 
                    % set all correction factors to 0 if restructured ASCII
                    % files are loaded, since the factors have already been
                    % applied
                    
                    % modified by MH, 29.3.2019
                    % coefficients
%                     for l = 1:nExc
%                         for c = 1:nChan
                            % bleedthrough
%                             p.proj{i}.curr{n}{5}{1}{l,c} = zeros(1,nChan-1);
                            % direct excitation
%                             if ~isempty(p.proj{i}.curr{n}{5}{2}{1,c})
%                                 p.proj{i}.curr{n}{5}{2}{l,c} = zeros(1,nExc-1);
%                             end
%                         end
%                     end
                    p.proj{i}.curr{n}{5}{1} = zeros(1,nChan-1);
                    p.proj{i}.curr{n}{5}{2} = zeros(nExc-1,nChan);
                    
                end
            end
            
            % if the molecule parameter "window size" does not belong to 
            % the background correction parameters
            if p.proj{i}.is_movie
                for l = 1:p.proj{i}.nb_excitations
                    for c = 1:p.proj{i}.nb_channel
                        if size(p.proj{i}.curr{n}{3},2)>=4 && ...
                                p.proj{i}.curr{n}{3}(4)>0
                            p.proj{i}.curr{n}{3}{3}{l,c}( ...
                                p.proj{i}.curr{n}{3}{3}{l,c}(:,2)'==0,2) = ...
                                p.proj{i}.curr{n}{3}(4);
                        elseif p.proj{i}.fix{1}(2)>0
                            p.proj{i}.curr{n}{3}{3}{l,c}( ...
                                p.proj{i}.curr{n}{3}{3}{l,c}(:,2)'==0,2) = ...
                                p.proj{i}.fix{1}(2);
                        else
                            p.proj{i}.curr{n}{3}{3}{l,c}( ...
                                p.proj{i}.curr{n}{3}{3}{l,c}(:,2)'==0,2) = 20;
                        end
                        % for histothresh, the parameter should be <= 1.
                        if p.proj{i}.curr{n}{3}{3}{l,c}(5,1)>1
                            p.proj{i}.curr{n}{3}{3}{l,c}(5,1) = 0.5;
                        end
                        % for median, the parameter should be 1 or 2.
                        if ~(p.proj{i}.curr{n}{3}{3}{l,c}(7,1)==1 || ...
                                p.proj{i}.curr{n}{3}{3}{l,c}(7,1)==2)
                            p.proj{i}.curr{n}{3}{3}{l,c}(7,1) = 2;
                        end
                    end
                end
            end
            
            if size(p.proj{i}.curr{n}{3},2)>=4
                p.proj{i}.curr{n}{3}(4) = [];
            end
        end
    end
    
    % set last-improted project as current project
    p.curr_proj = size(p.proj,2);
    
    % update project list
    p = ud_projLst(p, h.listbox_traceSet);
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);

    % display action
    if size(fname,2) > 1
        str_files = 'files:\n';
    else
        str_files = 'file: ';
    end
    for i = 1:size(fname,2)
        str_files = cat(2,str_files,pname,fname{i},'\n');
    end
    str_files = str_files(1:end-2);
    setContPan(['Project successfully imported from ' str_files],'success',...
        h.figure_MASH);
    
    % update GUI according to new project parameters
    ud_TTprojPrm(h.figure_MASH);
    
    % update sample management area
    ud_trSetTbl(h.figure_MASH);
    
    % update calculations and GUI
    updateFields(h.figure_MASH, 'ttPr');
end
