function pushbutton_addTraces_Callback(obj, evd, h_fig)

% Last update, 13.1.2020 by MH: move down-compatibility management to separate function downCompatibilityTP.m
% update, 3.4.2019 by MH: (1) adapt gamma factor import for more than one FRET calculation (2) correct MH's past modifications: gamma factors must be saved in prm and in curr parameters to be taken into account
% update, 2.4.2019 by MH: fix error when importing ASCII traces: correct dimensions of bleedthrough coefficients when resetting cross-talks to 0. (2) reset cross-talks to 0 whether or not gamma files were successfully imported or not.
% update, 29.3.2019 by MH: cancel saving of ASCII-improted gamma factors in p.proj{i}.prm: if save in prm, molecule won't be processed with new gammas
% update, 28.3.2019 by MH: For ASCII traces import: gamma factors files are recovered from import options
% update, 28.3.2018 by FS: if ASCII file and not MASH project is loaded: load gamma factor file if it exists; assign gamma value only if number of values in .gam file equals the number of loaded restructured ASCII files

% collect files to import
h = guidata(h_fig);

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname,filesep)
        pname = [pname,filesep];
    end
else
    defPth = h.folderRoot;
    [fname,pname,o] = uigetfile({'*.mash', 'MASH project(*.mash)'; '*.*', ...
        'All files(*.*)'},'Select trace files',defPth,'MultiSelect','on');
end
if isempty(pname) || ~sum(pname)
    return
end
    
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
    return
end

% load project data
[dat,ok] = loadProj(pname, fname, 'intensities', h_fig);
if ~ok
    return
end
p.proj = [p.proj dat];

% load gamma factor file if it exists; added by FS, 28.3.2018
isBeta = false;
isGamma = false;
[o,o,fext] = fileparts(fname{1});
if ~strcmp(fext, '.mash') % if ASCII file and not MASH project is loaded
    nMolFiles = numel(fname);

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
        if size(gammas,1) ~= nMolFiles
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
        if size(betas,1) ~= nMolFiles
            updateActPan(cat(2,'number of beta factors does not ',...
                'match the number of ASCII files loaded. Set all ',...
                'beta factors to 1.'), h_fig, 'error');
            isBeta = false;
        end
    end
end

% define molecule processing parameters applied (prm) and to apply
% (curr)
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

    p.proj{i}.fix = p.defProjPrm.general;
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

    if ~strcmp(fext, '.mash')
        % added by MH, 13.1.2020
        % reset cross-talks if ASCII import
        p.proj{i}.fix{4}{1} = zeros(nChan,nChan-1);
        p.proj{i}.fix{4}{2} = zeros(nExc-1,nChan);
    end

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
end

% set last-improted project as current project
p.curr_proj = size(p.proj,2);

% update project list
p = ud_projLst(p, h.listbox_traceSet);
h.param.ttPr = p;
guidata(h_fig, h);

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
    h_fig);

% update GUI according to new project parameters
ud_TTprojPrm(h_fig);

% update sample management area
ud_trSetTbl(h_fig);

% update calculations and GUI
updateFields(h_fig, 'ttPr');
