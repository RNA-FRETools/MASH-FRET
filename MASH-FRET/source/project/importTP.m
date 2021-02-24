function p = importTP(p,dat,fext,nFiles,h_fig)
% p = importTP(p,dat,fext,nFiles,h_fig)
%
% p: structure containing parameters for Trace processing interface
% dat: structure containing project data
% nFiles: number of imported files
% h_fig: handle to main figure

% defaults
resetCrossTalks = false;
isBeta = false;
isGamma = false;

% add project to list
p.proj = [p.proj dat];

% load gamma factor file if it exists; added by FS, 28.3.2018
if ~strcmp(fext, '.mash') % if ASCII file and not MASH project is loaded
    resetCrossTalks = true;

    % added by MH, 28.3.2019
    pnameGamma = p.impPrm{6}{2};
    fnameGamma = p.impPrm{6}{3};
    isGamma = p.impPrm{6}{1} & ~isempty(fnameGamma) & sum(pnameGamma);
    if isGamma
        gammasCell = cell(1,length(fnameGamma));
        for f = 1:length(fnameGamma)
            filename = [pnameGamma fnameGamma{f}];
            content = importdata(filename);
            if isstruct(content)
                gammasCell{f} = content.data;
            else
                gammasCell{f} = content;
            end
        end
        gammas = cell2mat(gammasCell');

        % added by FS, 28.3.2018
        if size(gammas,1) ~= nFiles
            updateActPan(cat(2,'number of gamma factors does not ',...
                'match the number of ASCII files loaded. Set all ',...
                'gamma factors to 1.'), h_fig, 'error');
            isGamma = false;
        end
    end

    % added by MH, 16.1.2020
    pnameBeta = p.impPrm{6}{5};
    fnameBeta = p.impPrm{6}{6};
    isBeta = p.impPrm{6}{4} & ~isempty(fnameBeta) & sum(pnameBeta);
    if isBeta
        betasCell = cell(1,length(fnameBeta));
        for f = 1:length(fnameBeta)
            filename = [pnameBeta fnameBeta{f}];
            content = importdata(filename);
            if isstruct(content)
                betasCell{f} = content.data;
            else
                betasCell{f} = content;
            end
        end
        betas = cell2mat(betasCell');
        if size(betas,1) ~= nFiles
            updateActPan(cat(2,'number of beta factors does not ',...
                'match the number of ASCII files loaded. Set all ',...
                'beta factors to 1.'), h_fig, 'error');
            isBeta = false;
        end
    end
end

% define molecule processing parameters applied (prm) and to apply (curr)
for i = (size(p.proj,2)-size(dat,2)+1):size(p.proj,2)

    % moved here by MH, 29.3.2019
    nMol = numel(p.proj{i}.coord_incl);
    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;

    % added by MH,29.3.2019
    exc = p.proj{i}.excitations;
    chanExc = p.proj{i}.chanExc;

    p.curr_mol(i) = 1;
    p.defProjPrm = setDefPrm_traces(p,i);
    
    if ~isfield(p.proj{i}, 'fixTT')
        p.proj{i}.fix = p.defProjPrm.general;
    else
        p.proj{i}.fix = p.proj{i}.fixTT;
        p.proj{i} = rmfield(p.proj{i}, 'fixTT');
    end
    
    p.proj{i}.def = p.defProjPrm;

    % modified by MH, 13.1.2020
%         mol_prev = p.proj{i}.def.mol{5};
    de_bywl = p.proj{i}.def.general{4}{2};

    if size(de_bywl,2)>0
        for c = 1:nChan
            if sum(exc==chanExc(c)) % emitter-specific illumination
                % reorder the direct excitation coefficients according to 
                % laser chronological order
                exc_but_c = exc(exc~=chanExc(c));
                if isempty(exc_but_c)
                    continue
                end
                [o,id] = sort(exc_but_c,'ascend'); % chronological index sorted as wl

                % modified by MH, 13.1.2020
%                 p.proj{i}.def.mol{5}{2}(id,c) = gen_prev{2}(:,c);
                p.proj{i}.def.general{4}{2}(id,c) = de_bywl(:,c);
            end
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

    if resetCrossTalks
        % added by MH, 13.1.2020
        % reset cross-talks if ASCII import
        p.proj{i}.fix{4}{1} = zeros(nChan,nChan-1);
        p.proj{i}.fix{4}{2} = zeros(nExc-1,nChan);
    end

    p.proj{i}.curr = cell(1,nMol);
    for n = 1:nMol % set current param. for all mol.
        if n > size(p.proj{i}.prm,2)
            p.proj{i}.prm{n} = {};
        end

        p.proj{i} = downCompatibilityTP(p.proj{i},n);

        % if size of already applied parameters is different from
        % defaults, used defaults
        p.proj{i}.curr{n} = adjustVal(p.proj{i}.prm{n}, ...
            p.proj{i}.def.mol);

        % added by FS, 28.3.2018
        % assign gamma value (assignment only works if number of values in .gam file equals the number of loaded restructured ASCII files)
        if isGamma

            % added by MH, 16.1.2020
            nG = size(gammas,2);
            if size(p.proj{i}.curr{n}{6}{1},2)<nG
                p.proj{i}.curr{n}{6}{1} = cat(2,...
                    p.proj{i}.curr{n}{6}{1},ones(2,nG-...
                    size(p.proj{i}.curr{n}{6}{1},2)));
            end

            % modified by MH, 16.1.2020
%                 % set the gamma factor from the .gam file 
%                 % (FRET is calculated on the spot based on imported and corrected
%                 % intensities)
%                 p.proj{i}.curr{n}{6}{1} = gammas(n,:);
            p.proj{i}.curr{n}{6}{1}(1,1:nG) = gammas(n,:);

            % cancelled by MH, 13.1.2020
%                     p.proj{i}.prm{n}{6}{1} = gammas(n,:);

        end

        % added by MH, 16.1.2020
        if isBeta
            % added by MH, 16.1.2020
            nB = size(betas,2);
            if size(p.proj{i}.curr{n}{6}{1},2)<nB
                p.proj{i}.curr{n}{6}{1} = cat(2,...
                    p.proj{i}.curr{n}{6}{1},ones(2,nB-...
                    size(p.proj{i}.curr{n}{6}{1},2)));
            end

            p.proj{i}.curr{n}{6}{1}(2,1:nB) = betas(n,:);
        end
    end
    p.proj{i}.prm = p.proj{i}.prm(1:nMol);
    p.proj{i}.curr = p.proj{i}.curr(1:nMol);
end
