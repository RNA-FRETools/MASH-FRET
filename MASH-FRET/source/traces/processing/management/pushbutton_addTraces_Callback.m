function pushbutton_addTraces_Callback(obj, evd, h)
defPth = h.folderRoot;
[fname,pname,o] = uigetfile({'*.mash', 'MASH project(*.mash)'; '*.*', ...
    'All files(*.*)'}, 'Select trace files', defPth, 'MultiSelect', 'on');
if ~isempty(fname) && ~isempty(pname) && sum(pname)
    if ~iscell(fname)
        fname = {fname};
    end
    [dat ok] = loadProj(pname, fname, 'intensities', h.figure_MASH);
    if ~ok
        return;
    end
    p = h.param.ttPr;
    p.proj = [p.proj dat];
    
    % load gamma factor file if it exists; added by FS, 28.3.2018
    [o,o,fext] = fileparts(fname{1});
    if ~strcmp(fext, '.mash') % if ASCII file and not MASH project is loaded
            [fnameGamma,pnameGamma,~] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
    'All files(*.*)'}, 'Select gamma factor file', defPth, 'MultiSelect', 'on');
        if ~isempty(fnameGamma) && ~isempty(pnameGamma) && sum(pnameGamma)
            if ~iscell(fnameGamma)
                fnameGamma = {fnameGamma};
            end
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


    for i = (size(p.proj,2)-size(dat,2)+1):size(p.proj,2)
        p.curr_mol(i) = 1;
        p.defProjPrm = setDefPrm_traces(p,i);

        p.proj{i}.fix = p.defProjPrm.general;
        p.proj{i}.def = p.defProjPrm;

        % reorder the cross talk coefficients chronologically
        [o,id] = sort(p.proj{i}.excitations,'ascend'); % chronological index sorted as wl
        mol_prev = p.proj{i}.def.mol{5};
        for c = 1:p.proj{i}.nb_channel
            p.proj{i}.def.mol{5}{1}(id,c) = mol_prev{1}(:,c);
            p.proj{i}.def.mol{5}{2}(id,c) = mol_prev{2}(:,c);
        end

        if ~isfield(p.proj{i}, 'expTT')
            p.proj{i}.exp = [];
        else
            p.proj{i}.exp = p.proj{i}.expTT;
            p.proj{i} = rmfield(p.proj{i}, 'expTT');
        end
        p.proj{i}.exp = setExpOpt(p.proj{i}.exp, p.proj{i});
        
        nMol = numel(p.proj{i}.coord_incl);
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
                    p.proj{i}.prm{n}{5}{3} = gammas(n);
                end
                if ~isempty(fnameGamma) && ~isempty(pnameGamma)
                    % Cross talk and filter corrections 
                    % set all correction factors to 0 if restructured ASCII
                    % files are loaded, since the factors have already been
                    % applied
                    nChan = p.proj{i}.nb_channel;
                    nExc = p.proj{i}.nb_excitations;
                    for l = 1:nExc
                        for c = 1:nChan
                            % bleedthrough
                            p.proj{i}.curr{n}{5}{1}{l,c} = zeros(1,nChan-1);
                            % direct excitation
                            if ~isempty(p.proj{i}.curr{n}{5}{2}{1,c})
                                p.proj{i}.curr{n}{5}{2}{l,c} = zeros(1,nExc-1);
                            end
                        end
                    end
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
            % the maximum number of state for CPA should be Inf
            for j = 1:size(p.proj{i}.curr{n}{4}{2},3)
                if isfinite( p.proj{i}.curr{n}{4}{2}(4,2,j))
                     p.proj{i}.curr{n}{4}{2}(4,2,j) = Inf;
                end
            end
        end
    end
    p.curr_proj = size(p.proj,2);

    str_files = 'file';
    if size(fname,2) > 1
        str_files = [str_files 's'];
    end
    for i = 1:size(fname,2)
        str_files = [str_files '\n' fname{i}];
    end

    p = ud_projLst(p, h.listbox_traceSet);
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    
    ud_TTprojPrm(h.figure_MASH);
    ud_trSetTbl(h.figure_MASH);
    updateFields(h.figure_MASH, 'ttPr');
    
    updateActPan(['Traces have been successfully imported from ' ...
        str_files '\n in folder: ' pname], h.figure_MASH, 'success');
end
