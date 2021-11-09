function p = importTP(p,projs)
% p = importTP(p,projs)
%
% Ensure proper import of input projects' TP processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define molecule processing parameters applied (prm) and to apply (curr)
for i = projs
    if isempty(p.proj{i}.TP)
        continue
    end
    
    % collect experiment settings
    N = numel(p.proj{i}.coord_incl);
    nChan = p.proj{i}.nb_channel;
    exc = p.proj{i}.excitations;
    chanExc = p.proj{i}.chanExc;
    if isempty(p.proj{i}.traj_import_opt)
        isGamma = false;
        isBeta = false;
    else
        pnameGamma = p.proj{i}.traj_import_opt{6}{2};
        fnameGamma = p.proj{i}.traj_import_opt{6}{3};
        pnameBeta = p.proj{i}.traj_import_opt{6}{5};
        fnameBeta = p.proj{i}.traj_import_opt{6}{6};

        isGamma = p.proj{i}.traj_import_opt{6}{1} & ~isempty(fnameGamma) & ...
            sum(pnameGamma);
        isBeta = p.proj{i}.traj_import_opt{6}{4} & ~isempty(fnameBeta) & ...
            sum(pnameBeta);
    end

    % set default processing parameters
    p.ttPr.defProjPrm = setDefPrm_traces(p,i); % interface default
    p.proj{i}.TP.def = p.ttPr.defProjPrm; % project default
    
    % reorder DE coefficients according to laser chronological order
    de_bywl = p.proj{i}.TP.def.general{4}{2};
    if size(de_bywl,2)>0
        for c = 1:nChan
            if sum(exc==chanExc(c))
                exc_but_c = exc(exc~=chanExc(c));
                if isempty(exc_but_c)
                    continue
                end
                [o,id] = sort(exc_but_c,'ascend');
                p.proj{i}.TP.def.general{4}{2}(id,c) = de_bywl(:,c);
            end
        end
    end
    
    % set global TP processing parameters
    if ~isfield(p.proj{i}.TP,'fix')
        p.proj{i}.TP.fix = p.ttPr.defProjPrm.general;
    end
    
    % initializes export options
    if ~isfield(p.proj{i}.TP, 'exp')
        p.proj{i}.TP.exp = [];
    end
    p.proj{i}.TP.exp = setExpOpt(p.proj{i}.TP.exp, p.proj{i});
    
    % initializes applied processing parameters 
    if ~isfield(p.proj{i}.TP, 'prm')
        p.proj{i}.TP.prm = cell(1,N); % empty param. for all mol.
    end
    
    % initializes current processing parameters
    p.proj{i}.TP.curr = cell(1,N);
    
    % adjust curr and prm to current standard
    for n = 1:N 
        if n>size(p.proj{i}.TP.prm,2)
            p.proj{i}.TP.prm{n} = {};
        end

        p.proj{i} = downCompatibilityTP(p.proj{i},n);

        % if size of prm is different from def, use def
        p.proj{i}.TP.curr{n} = adjustVal(p.proj{i}.TP.prm{n}, ...
            p.proj{i}.TP.def.mol);

    end
    
    % load gamma factor file if it exists; added by FS, 28.3.2018
    % added by MH, 28.3.2019
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
            setContPan(cat(2,'The number of gamma factors does not match ',...
                'the number of trajectory files. All gamma factors are ',...
                'set to 1.'),'error',h_fig);
            isGamma = false;
        end
    end

    % added by MH, 16.1.2020
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
            setContPan(cat(2,'The number of beta factors does not match ',...
                'the number of trajectory files. All beta factors are set',...
                ' to 1.'),'error',h_fig);
            isBeta = false;
        end
    end
    
    % added by FS, 28.3.2018
    % assign gamma value (assignment only works if number of values in .gam file equals the number of loaded restructured ASCII files)
    if isGamma
        % added by MH, 16.1.2020
        nG = size(gammas,2);
        if size(p.proj{i}.curr{n}{6}{1},2)<nG
            p.proj{i}.curr{n}{6}{1} = cat(2,p.proj{i}.curr{n}{6}{1},...
                ones(2,nG-size(p.proj{i}.curr{n}{6}{1},2)));
        end
        p.proj{i}.curr{n}{6}{1}(1,1:nG) = gammas(n,:);
    end

    % added by MH, 16.1.2020
    if isBeta
        % added by MH, 16.1.2020
        nB = size(betas,2);
        if size(p.proj{i}.curr{n}{6}{1},2)<nB
            p.proj{i}.curr{n}{6}{1} = cat(2,p.proj{i}.curr{n}{6}{1},...
                ones(2,nB-size(p.proj{i}.curr{n}{6}{1},2)));
        end
        p.proj{i}.curr{n}{6}{1}(2,1:nB) = betas(n,:);
    end
    
    p.proj{i}.TP.prm = p.proj{i}.TP.prm(1:N);
    p.proj{i}.TP.curr = p.proj{i}.TP.curr(1:N);
end
