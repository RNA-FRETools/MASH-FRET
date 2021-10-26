function saveProcAscii(h_fig, p, xp, pname, name)
% Export processed and calculated data from Trace processing to files.
% "h_fig" >> MASH figure handle
% "p" >> Project parameters in Trace processing
% "xp" >> Export settings
% "pname" >> destination folder
% "name" >> destination file name

% Last update by MH, 16.1.2019: export beta factors
% update by MH, 24.4.2019: adapt code to new molecule tag structure
% update: by MH 22.4.2019 by MH: correct rate in SMART-compatible files
% update: by MH, 3.4.2019: correct export of gamma factors for multiple FRET channels
% update: by MH, 20.2.2019: modify dwell time file header for coherence with simulation
% update: by MH, 17.2.2019: (1) optimize code synthaxe (2) remove units "per second" and "per pixel" (always export in counts to avoid confusion when importing exported ASCII traces) (3) add headers to histogram and dwell-time files
% update: by FS, 26.4.2019: display error message if no molecules with specified tag are found
% update: by FS, 25.4.2019: correct molecule index when specific tags are exported
% update: by FS, 24.4.2018: adapt export to specific molecule tags
% update: by FS, 19.3.2018: export gamma factors to files

h = guidata(h_fig);

% saveProcAscii is/isn't called from trace processing export window
% (openExpTtpr.m)--> can be called in a routine:
fromTT = isequalwithequalnans(p, h.param);

%% collect project parameters

proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;
coord = p.proj{proj}.coord;
molTagNames = p.proj{proj}.molTagNames;
molTag = p.proj{proj}.molTag;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
expT = p.proj{proj}.frame_rate; % MH: this is the EXPOSURE TIME
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
FRET_DTA = p.proj{proj}.FRET_DTA;
S_DTA = p.proj{proj}.S_DTA;
intensities = p.proj{proj}.intensities_denoise;
intensities_DTA = p.proj{proj}.intensities_DTA;
nMol = size(intensities,2)/nC;
if fromTT && xp.mol_valid
    mol_incl = p.proj{proj}.coord_incl;
else
    mol_incl = true(1,nMol);
end
mol_TagVal = p.proj{proj}.TP.exp.mol_TagVal;

% added by FS, 24.4.2018
if mol_TagVal > numel(molTagNames)
    
    % modified by MH, 24.4.2019
%     mol_incl_tag = mol_incl;
    mol_incl_tag = true(1,nMol);
    
else
    
    % modified by MH, 24.4.2019
%     mol_incl_tag = p.proj{proj}.molTag == mol_TagVal;
    mol_incl_tag = molTag(:,mol_TagVal)';
    
end


%N = numel(find(mol_incl));
N = numel(find(mol_incl & mol_incl_tag)); % added by FS, 24.4. 2018
nFRET = size(FRET,1);
nS = size(S,1);
nExc = numel(exc);

if ~fromTT
    intensities_DTA = p.proj{proj}.adj.intensities_DTA;
end

% export intensity in counts per frame (fixed units)
iunits = 'counts';

if ~fromTT
    FRET_DTA = p.proj{proj}.adj.FRET_DTA;
    S_DTA = p.proj{proj}.adj.S_DTA;
end


%% collect export options: traces

saveTr = xp.traces{1}(1);
if saveTr
    saveAscii = false;
    saveHa = false;
    saveVbfret = false;
    saveSmart = false;
    saveQub = false;
    saveEbfret = false;
    saveFact = false;
    
    if sum(double(xp.traces{1}(2) == [1 7]))
        saveAscii = true; % one file/mol
        pname_ascii = setCorrectPath(cat(2,pname,'traces_ASCII'),h_fig);
    end
    if sum(double(xp.traces{1}(2) == [2 7])) && nFRET > 0
        saveHa = true; % one file/mol
        pname_ha = setCorrectPath(cat(2,pname,'traces_HaMMy'),h_fig);
    end
    if sum(double(xp.traces{1}(2) == [3 7])) && nFRET > 0
        saveVbfret = true; % all mol in one file
        pname_vbfret = setCorrectPath(cat(2,pname,'traces_vbFRET'), h_fig);
    end
    if sum(double(xp.traces{1}(2) == [4 7])) && nFRET > 0
        saveSmart = true; % all mol in one file
        pname_smart = setCorrectPath(cat(2,pname,'traces_SMART'),h_fig);
    end
    if sum(double(xp.traces{1}(2) == [5 7])) && nFRET > 0
        saveQub = true; % one file/mol
        pname_qub = setCorrectPath(cat(2,pname,'traces_QUB'),h_fig);
    end
    if sum(double(xp.traces{1}(2) == [6 7])) && nFRET > 0
        saveEbfret = true; % one file/mol
        data_ebfret = cell(1,nFRET);
        pname_ebfret = setCorrectPath(cat(2,pname,'traces_ebFRET'),h_fig);
    end
    if xp.traces{2}(6) && nFRET > 0
        saveFact = true;  % added by FS, 19.3.2018
    end
    saveTr_I = xp.traces{2}(1);
    saveTr_fret = ~~xp.traces{2}(2) & nFRET > 0;
    saveTr_S = ~~xp.traces{2}(3) & nS > 0;
    allInOne = ~~xp.traces{2}(4);
    savePrm = xp.traces{2}(5); % external file/in trace file/none
    pname_xp = setCorrectPath([pname 'parameters'], h_fig);
end

%% collect export options: histograms

saveHist = xp.hist{1}(1);
if saveHist
    pname_hist = setCorrectPath([pname 'histograms'], h_fig);
    inclDiscr = xp.hist{1}(2);
    saveHst_I = xp.hist{2}(1,1);
    minI = xp.hist{2}(1,2);
    binI = xp.hist{2}(1,3);
    maxI = xp.hist{2}(1,4);
    
    saveHst_fret = ~~xp.hist{2}(2,1) & nFRET > 0;
    minFret = xp.hist{2}(2,2);
    binFret = xp.hist{2}(2,3);
    maxFret = xp.hist{2}(2,4);

    saveHst_S = ~~xp.hist{2}(3,1) & nS > 0;
    minS = xp.hist{2}(3,2);
    binS = xp.hist{2}(3,3);
    maxS = xp.hist{2}(3,4);
end

%% collect export options: dwell-times

saveDt = xp.dt{1};
if saveDt
    pname_dt = setCorrectPath([pname 'dwell-times'], h_fig);
    saveDt_I = xp.dt{2}(1);
    if  nFRET > 0
        saveDt_fret = xp.dt{2}(2);
    else
        saveDt_fret = 0;
    end
    if  nS > 0
        saveDt_S = xp.dt{2}(3);
    else
        saveDt_S = 0;
    end
    
    saveKin = xp.dt{2}(4);
    if saveKin
        fname_kinI = [name '_I.kin'];
        fname_kinI = overwriteIt(fname_kinI,pname_dt,h_fig);
        if isempty(fname_kinI)
            return;
        end

        fname_kinF = [name '_FRET.kin'];
        fname_kinF = overwriteIt(fname_kinF,pname_dt,h_fig);
        if isempty(fname_kinF)
            return;
        end

        fname_kinS = [name '_S.kin'];
        fname_kinS = overwriteIt(fname_kinS,pname_dt,h_fig);
        if isempty(fname_kinS)
            return;
        end
    end
else
    saveKin = false;
end


%% collect export options: figures

saveFig = xp.fig{1}(1);
if saveFig
    pname_fig = setCorrectPath([pname 'figures'], h_fig);
    figFmt = xp.fig{1}(2); % pdf/png/jpg
    molPerFig = xp.fig{1}(3);
    p_fig.isSubimg = xp.fig{1}(4);
    p_fig.isHist = xp.fig{1}(5);
    p_fig.isDiscr = xp.fig{1}(6);
    p_fig.isTop = xp.fig{2}{1}(1);
    p_fig.topExc = xp.fig{2}{1}(2);
    p_fig.topChan = xp.fig{2}{1}(3);
    if nFRET > 0 || nS > 0
        p_fig.isBot = xp.fig{2}{2}(1);
        p_fig.botChan = xp.fig{2}{2}(2);
    else
        p_fig.isBot = 0;
        p_fig.botChan = 0;
    end
    %[o,m_ind,o] = find(mol_incl);
    [o,m_ind,o] = find(mol_incl & mol_incl_tag); % added by FS, 25.4.2018
    if isempty(m_ind) % error message if no molecules with specified tag are found; added by FS, 26.4.2018
        updateActPan('No molecules with the specified tag are found', ...
            h_fig, 'error');
        return
    end
    m_start = m_ind(1);
    m_end = m_ind(end);
    if figFmt==1 %pdf
        nfig = 1;
        fname_fig = {};
        pname_fig_temp = cat(2,pname_fig,'temp');
        if ~exist(pname_fig_temp,'dir')
            mkdir(pname_fig_temp);
        end
    end
end

%% export data to files: 

setContPan('Export processed data for selected molecules ...','process',...
    h_fig);

% loading bar parameters---------------------------------------------------
err = loading_bar('init', h_fig , nMol, ...
    'Export processed data for selected molecules ...');
if err
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% -------------------------------------------------------------------------

gammaAll = NaN(nMol,nFRET);  % added by FS, 19.3.2018
betaAll = NaN(nMol,nS); % added by MH, 16.1.2020

n = 0;
try
    for m = 1:nMol
        if ~(mol_incl(m) && mol_incl_tag(m))  % added by FS, 24.4.2018
            continue
        end
            
        % increment number of exported molecules
        n = n + 1;

        % display action
        disp(cat(2,'export data of molecule n:°',num2str(m),'(',num2str(n),...
            ' on ',num2str(N),')...'));

        % if requested, process molecule data before exporting
        if fromTT && xp.process
            h = guidata(h_fig);
            h.mute_actions = true;
            guidata(h_fig,h);

            % process data
            p = updateTraces(h_fig, 'ttPr', m, p, []);
            
            h = guidata(h_fig);
            h.mute_actions = false;
            guidata(h_fig,h);

            % collect processed data
            intensities = p.proj{proj}.intensities_denoise;
            intensities_DTA = p.proj{proj}.intensities_DTA;
            FRET_DTA = p.proj{proj}.FRET_DTA;
            S_DTA = p.proj{proj}.S_DTA;
        end

        % build frame and time column
        incl = p.proj{proj}.bool_intensities(:,m);
        [frames,o,o] = find(incl);
        frames = ((nExc*(frames(1)-1)+1):nExc*frames(end))';
        times = frames*expT;

        % build molecule file name
        name_mol = [name '_mol' num2str(m) 'of' num2str(nMol)];

        % intensity traces are/aren't discretized
        if fromTT
            discrInt = ~p.proj{proj}.TP.prm{m}{4}{1}(2) || ...
                p.proj{proj}.TP.prm{m}{4}{1}(2)==2;
        else
            discrInt = 1;
        end

        % select molecule intensity data
        int_m = intensities(incl,((m-1)*nC+1):m*nC,:);
        intDTA_m = intensities_DTA(incl,((m-1)*nC+1):m*nC,:);

        % format molecule processing parameters
        if fromTT && saveTr && (savePrm<3) % save parameters
            str_xp = getStrPrm(p.proj{proj}, m, mol_incl&mol_incl_tag,...
                h_fig);
        else
            str_xp = '';
        end
        
        if fromTT
            gamma = p.proj{proj}.TP.prm{m}{6}{1}(1,:);
            beta = p.proj{proj}.TP.prm{m}{6}{1}(2,:);
        else
            gamma = ones(1,nFRET);
            beta = ones(1,nFRET);
        end

        %% export traces

        if saveTr && saveAscii
            % initialize data to write in file
            head_I = [];    fmt_I = [];    dat_I = [];
            head_fret = []; fmt_fret = []; dat_fret = [];
            head_s = [];    fmt_s = [];    dat_s = [];

            if saveTr_I
                % format intensity data
                [head_I,fmt_I,dat_I] = formatInt2File(exc, ...
                    [times,frames],cat(2,int_m,intDTA_m),iunits,...
                    discrInt);
                
                % write data to intensity file
                if ~allInOne && ~writeDat2file(cat(2,pname_ascii,name_mol),...
                        '_I.txt',{head_I,fmt_I,dat_I},[fromTT,savePrm],...
                        str_xp,h_fig)
                    return
                end
            end

            if saveTr_fret
                % calculate FRET
                FRET_all = calcFRET(nC,nExc,exc,chanExc,FRET,...
                    int_m,gamma);
                FRET_DTA_all = FRET_DTA(incl,(m-1)*nFRET+1:m*nFRET);

                % format FRET data
                [head_fret,fmt_fret,dat_fret] = formatFret2File(...
                    exc,chanExc,[times,frames],cat(2,FRET_all,...
                    FRET_DTA_all),FRET);
                
                % write data to FRET file
                if ~allInOne && ~writeDat2file(cat(2,pname_ascii,name_mol),...
                        '_FRET.txt',{head_fret,fmt_fret,dat_fret},...
                        [fromTT,savePrm],str_xp,h_fig)
                    return
                end
            end

            if saveTr_S
                % calculate Stoichiometry
                S_all = calcS(exc,chanExc,S,FRET,int_m,gamma,beta);
                S_DTA_all = S_DTA(incl,(m-1)*nS+1:m*nS);

                % format Stoichiometry data
                [head_s,fmt_s,dat_s] = formatS2File(exc,chanExc,...
                    [times,frames],cat(2,S_all,S_DTA_all),S);
                
                % write data to stoichiometry file
                if ~allInOne && ~writeDat2file(cat(2,pname_ascii,name_mol),...
                        '_S.txt',{head_s,fmt_s,dat_s},[fromTT,savePrm],...
                        str_xp,h_fig)
                    return
                end
            end

            if allInOne
                % write data in molecule file
                if ~writeDat2file(cat(2,pname_ascii,name_mol),'.txt',...
                        {head_I,fmt_I,dat_I;head_fret,fmt_fret,dat_fret;...
                        head_s,fmt_s,dat_s},[fromTT,savePrm],str_xp,h_fig)
                    return
                end
            end
        end

        % save traces compatible with external software
        if saveTr&&(saveHa||saveVbfret||saveSmart||saveEbfret||saveQub)

            for j = 1:nFRET
                % format intensity data for FRET calculation
                ext_f = cat(2,'FRET',num2str(FRET(j,1)),'to',...
                    num2str(FRET(j,2)));
                [o,l,o] = find(exc==chanExc(FRET(j,1)));
                I_fret{j}{n} = intensities(incl,[(m-1)*nC+FRET(j,1), ...
                    (m-1)*nC+FRET(j,2)],l);

                if saveHa
                    % format HaMMy data
                    [head,fmt,dat] = formatHa2File(times(l:nExc:end,1),...
                        I_fret{j}{n});

                    % write data to HaMMy file
                    if ~writeDat2file(cat(2,pname_ha,name_mol),...
                            cat(2,ext_f,'_HaMMy.dat'),{head,fmt,dat},...
                            [fromTT,0],'',h_fig)
                        return;
                    end
                end

                if saveSmart
                    % format SMART data
                    if ~p.proj{proj}.is_coord
                        dat_smart{j} = formatSmart2File(I_fret{j}{n},[n,N],...
                            1/(expT*nExc),zeros(numel(mol_incl),...
                            numel(2*FRET(j,1)-1:2*FRET(j,1))));
                    else
                        dat_smart{j} = formatSmart2File(I_fret{j}{n},[n,N],...
                            1/(expT*nExc),coord(mol_incl,...
                            (2*FRET(j,1)-1):2*FRET(j,1)));
                    end

                end

                if saveEbfret
                    % format ebFRET data
                    data_ebfret{j} = cat(1,data_ebfret{j},...
                        cat(2,ones(size(I_fret{j}{n},1),1)*n,...
                        I_fret{j}{n}));
                end

                if saveQub
                    % format QuB data
                    [head,fmt,dat] = formatQub2File(I_fret{j}{n});

                    % write data to QuB file
                    if ~writeDat2file(cat(2,pname_qub,name_mol),...
                            cat(2,ext_f,'_QUB.txt'),{head,fmt,dat},...
                            [fromTT,0],'',h_fig)
                        return;
                    end
                end
            end
        end
        
        % save parameters
        if saveTr && fromTT && savePrm==1 
            % write parameters to file
            if ~writeDat2file(cat(2,pname_xp,name_mol),'.log',...
                    {'',str_xp,[]},[fromTT,0],'',h_fig)
                return
            end
        end
        
        % format gamma factor data
        % added by FS, 19.3.2018
        if saveTr && saveFact
            for i = 1:nFRET
                if fromTT
                    gammaAll(m,i) = p.proj{proj}.TP.prm{m}{6}{1}(1,i);
                    betaAll(m,i) = p.proj{proj}.TP.prm{m}{6}{1}(2,i);
                else
                    gammaAll(m,i) = 1;
                    betaAll(m,i) = 1;
                end
            end
        end


        %% histograms

        if saveHist
            if saveHst_I

                x_I = minI:binI:maxI;

                for l = 1:nExc
                    for c = 1:nC

                        % format intensity histogram data
                        I = intensities(incl,(m-1)*nC+c,l);
                        histI = [];
                        histI(:,1) = x_I';
                        histI(:,2) = (hist(I,x_I))';
                        histI(:,3) = histI(:,2)/sum(histI(:,2));
                        histI(:,4) = cumsum(histI(:,2));
                        histI(:,5) = histI(:,4)/histI(end,4);

                        % build file name
                        fname_histI = cat(2,name_mol,'_I',num2str(c),...
                            '-',num2str(exc(l)),'.hist');
                        fname_histI = overwriteIt(fname_histI,...
                            pname_hist,h_fig);
                        if isempty(fname_histI)
                            return;
                        end

                        % write data to file
                        f = fopen(cat(2,pname_hist,fname_histI),'Wt');
                        fprintf(f,cat(2,'I',num2str(c),'-', ...
                            num2str(exc(l)),'\tfrequency count\t',...
                            'probability\tcumulative frequency ',...
                            'count\tcumulative probability\n'));
                        fprintf(f,cat(2,repmat('%d\t',...
                            [1,size(histI,2)]),'\n'),histI');
                        fclose(f);

                        if inclDiscr && discrInt
                            % format discrete intensity histogram
                            discrI = ...
                                intensities_DTA(incl,(m-1)*nC+c,l);
                            histdI = [];
                            histdI(:,1) = x_I';
                            histdI(:,2) = (hist(discrI,x_I))';
                            histdI(:,3) = ...
                                histdI(:,2)/sum(histdI(:,2));
                            histdI(:,4) = cumsum(histdI(:,2));
                            histdI(:,5) = histdI(:,4)/histdI(end,4);

                            % build file name
                            fname_histdI = cat(2,name_mol,'_I',num2str(c),...
                            '-',num2str(exc(l)),'_discr.hist');
                            fname_histdI = overwriteIt(fname_histdI,...
                                pname_hist,h_fig);
                            if isempty(fname_histdI)
                                return;
                            end

                            % write data to file
                            f = fopen(cat(2,pname_hist,fname_histdI),...
                                'Wt');
                            fprintf(f,cat(2,'discr.I',num2str(c),'-', ...
                                num2str(exc(l)),'\tfrequency count\t',...
                                'probability\tcumulative frequency ',...
                                'count\tcumulative probability\n'));
                            fprintf(f,cat(2,repmat('%d\t',...
                                [1,size(histdI,2)]),'\n'),histdI');
                            fclose(f);
                        end
                    end
                end
            end

            if saveHst_fret

                x_fret = minFret:binFret:maxFret;

                % calculate FRET data
                FRET_all = calcFRET(nC, nExc, exc, chanExc,FRET, ...
                    intensities(incl,(((m-1)*nC+1):m*nC),:),gamma);

                for i = 1:nFRET
                    % format FRET histogram
                    FRET_tr = FRET_all(:,i);
                    histF = [];
                    histF(:,1) = x_fret';
                    histF(:,2) = (hist(FRET_tr,x_fret))';
                    histF(:,3) = histF(:,2)/sum(histF(:,2));
                    histF(:,4) = cumsum(histF(:,2));
                    histF(:,5) = histF(:,4)/histF(end,4);

                    % build file name
                    fname_histF = cat(2,name_mol,'_FRET',...
                        num2str(FRET(i,1)),'to',num2str(FRET(i,2)),...
                        '.hist');
                    fname_histF = overwriteIt(fname_histF,pname_hist,...
                        h_fig);
                    if isempty(fname_histF)
                        return;
                    end

                    % write data to file
                    f = fopen(cat(2,pname_hist,fname_histF),'Wt');
                    fprintf(f,cat(2,'FRET\tfrequency count\t',...
                        'probability\tcumulative frequency count\t',...
                        'cumulative probability\n'));
                    fprintf(f,cat(2,repmat('%d\t',[1,size(histF,2)]),...
                        '\n'),histF');
                    fclose(f);

                    if inclDiscr
                        % format discrete FRET histogram
                        discrFRET = FRET_DTA(incl,(m-1)*nFRET+i);
                        histdF = [];
                        histdF(:,1) = x_fret';
                        histdF(:,2) = (hist(discrFRET,x_fret))';
                        histdF(:,3) = histdF(:,2)/sum(histdF(:,2));
                        histdF(:,4) = cumsum(histdF(:,2));
                        histdF(:,5) = histdF(:,4)/histdF(end,4);

                        % build file name
                        fname_histdF = cat(2,name_mol,'_FRET',...
                            num2str(FRET(i,1)),'to',num2str(FRET(i,2)),...
                            '_discr.hist');
                        fname_histdF = overwriteIt(fname_histdF,...
                            pname_hist,h_fig);
                        if isempty(fname_histdF)
                            return;
                        end

                        % write data to file
                        f = fopen(cat(2,pname_hist,fname_histdF),'Wt');
                        fprintf(f,cat(2,'discr.FRET\tfrequency count',...
                            '\tprobability\tcumulative frequency ',...
                            'count\tcumulative probability\n'));
                        fprintf(f,cat(2,repmat('%d\t',...
                            [1,size(histdF,2)]),'\n'),histdF');
                        fclose(f);
                    end
                end
            end

            if saveHst_S

                x_s = minS:binS:maxS;

                % calculate stoichiometry data
                S_all = calcS(exc,chanExc,S,FRET,intensities(incl,...
                    (((m-1)*nC+1):m*nC),:),gamma,beta);

                for i = 1:nS
                    % calculate stoichiometry data
                    S_tr = S_all(:,i);

                    % format stoichiometry histogram
                    histS = [];
                    histS(:,1) = x_s';
                    histS(:,2) = (hist(S_tr,x_s))';
                    histS(:,3) = histS(:,2)/sum(histS(:,2));
                    histS(:,4) = cumsum(histS(:,2));
                    histS(:,5) = histS(:,4)/histS(end,4);

                    % build file name
                    fname_histS = cat(2,name_mol,'_S',num2str(S(i,1)),...
                        'to',num2str(S(i,2)),'.hist');
                    fname_histS = overwriteIt(fname_histS,pname_hist,...
                        h_fig);
                    if isempty(fname_histS)
                        return;
                    end

                    % write data to file
                    f = fopen(cat(2,pname_hist,fname_histS),'Wt');
                    fprintf(f,cat(2,'S\tfrequency count\tprobability',...
                        '\tcumulative frequency count\tcumulative ',...
                        'probability\n'));
                    fprintf(f,cat(2,repmat('%d\t',[1,size(histS,2)]),...
                        '\n'),histS');
                    fclose(f);

                    if inclDiscr
                        % format discrete stoichiometry histogram
                        discrS = S_DTA(incl,(m-1)*nS+i);
                        histdS = [];
                        histdS(:,1) = x_s';
                        histdS(:,2) = (hist(discrS,x_s))';
                        histdS(:,3) = histdS(:,2)/sum(histdS(:,2));
                        histdS(:,4) = cumsum(histdS(:,2));
                        histdS(:,5) = histdS(:,4)/histdS(end,4);

                        % build file name
                        fname_histdS = cat(2,name_mol,'_S',...
                            num2str(S(i,1)),'to',num2str(S(i,2)),...
                            '_discr.hist');
                        fname_histdS = overwriteIt(fname_histdS,...
                            pname_hist,h_fig);
                        if isempty(fname_histdS)
                            return;
                        end

                        % write data to file
                        f = fopen(cat(2,pname_hist,fname_histdS),'Wt');
                        fprintf(f,cat(2,'discr.S\tfrequency count\t',...
                            'probability\tcumulative frequency count',...
                            '\tcumulative probability\n'));
                        fprintf(f,cat(2,repmat('%d\t',...
                            [1,size(histdS,2)]),'\n'),histdS');
                        fclose(f);
                    end
                end
            end
        end

        %% Dwell-times

        if saveDt
            if (saveDt_I  || saveKin) && discrInt
                for l = 1:nExc
                    for c = 1:nC

                        % format intensity dwell times
                        discr_I = ...
                            intensities_DTA(incl,(m-1)*nC+c,l);
                        dtI = getDtFromDiscr(discr_I, expT);

                        % build file name
                        fname_dtI = cat(2,name_mol,'_I',num2str(c),...
                            '-',num2str(exc(l)),'.dt');
                        fname_dtI = overwriteIt(fname_dtI,pname_dt,...
                            h_fig);
                        if isempty(fname_dtI)
                            return;
                        end

                        % write data to file
                        if saveDt_I
                            f = fopen(cat(2,pname_dt,fname_dtI),'Wt');
                            fprintf(f,cat(2,'dwell time (second)\t',...
                                'state\tstate after transition\n'));
                            fprintf(f,cat(2,repmat('%d\t',...
                                [1,size(dtI,2)]),'\n'),dtI');
                            fclose(f);
                        end

                        if saveKin && size(dtI,1)>1 && ...
                                numel(unique(dtI(:,2:3)))<=6
                            kinDat = getKinDat(dtI);
                            upgradeKinFile(cat(2,pname_dt,fname_kinI), ...
                                fname_dtI,kinDat);
                        end
                    end
                end
            end

            if saveDt_fret || saveKin
                for i = 1:nFRET

                    % format FRET dwell times
                    discr_F = FRET_DTA(incl,(m-1)*nFRET+i);
                    dtF = getDtFromDiscr(discr_F, expT);

                    % build file name
                    fname_dtF = cat(2,name_mol,'_FRET',num2str(...
                        FRET(i,1)),'to',num2str(FRET(i,2)),'.dt');
                    fname_dtF = overwriteIt(fname_dtF,pname_dt,h_fig);
                    if isempty(fname_dtF)
                        return;
                    end

                    % write data to file
                    if saveDt_fret
                        f = fopen(cat(2,pname_dt,fname_dtF),'Wt');
                        fprintf(f,cat(2,'dwell time (second)\tstate\t',...
                            'state after transition\n'));
                        fprintf(f,cat(2,repmat('%d\t',...
                            [1,size(dtF,2)]),'\n'),dtF');
                        fclose(f);
                    end

                    if saveKin && size(dtF,1)>1 && ...
                            numel(unique(dtF(:,2:3)))<=6
                        kinDat = getKinDat(dtF);
                        upgradeKinFile(cat(2,pname_dt,fname_kinF), ...
                            fname_dtF,kinDat)
                    end
                end
            end
            if saveDt_S || saveKin
                for i = 1:nS

                    % format stoichiometry dwell times
                    discr_S = S_DTA(incl,(m-1)*nS+i);
                    dtS = getDtFromDiscr(discr_S, expT);

                    % build file name
                    fname_dtS = cat(2,name_mol,'_S',num2str(S(i,1)),...
                        'to',num2str(S(i,2)),'.dt');
                    fname_dtS = overwriteIt(fname_dtS,pname_dt,h_fig);
                    if isempty(fname_dtS)
                        return;
                    end

                    % write data to file
                    if saveDt_S
                        f = fopen(cat(2,pname_dt,fname_dtS),'Wt');
                        fprintf(f,cat(2,'dwell time (second)\tstate\t',...
                            'state after transition\n'));
                        fprintf(f,cat(2,repmat('%d\t',[1,size(dtS,2)]),...
                            '\n'),dtS');
                        fclose(f);
                    end

                    if saveKin && size(dtS,1)>1 && ...
                            numel(unique(dtS(:,2:3)))<=6
                        kinDat = getKinDat(dtS);
                        upgradeKinFile(cat(2,pname_dt,fname_kinS), ...
                            fname_dtS,kinDat)
                    end
                end
            end
        end

        %% Figures
        if saveFig
            if m == m_start
                h_fig_mol = [];
                n_prev = n;
                m_i = 0;
            end

            m_i = m_i+1;

            p2 = p;
            if ~fromTT
                if isfield(p.proj{proj},'prmTT')
                    p2.proj{proj}.TP.prm = p.proj{proj}.prmTT;
                end
                p2.proj{proj}.intensities_DTA = ...
                    p2.proj{proj}.adj.intensities_DTA;
                p2.proj{proj}.FRET_DTA = ...
                    p2.proj{proj}.adj.FRET_DTA;
                p2.proj{proj}.S_DTA = p2.proj{proj}.adj.S_DTA;
            end

            h_fig_mol = buildFig(p2,m,m_i,molPerFig,p_fig,h_fig_mol);

            if m_i == molPerFig || m == m_end
                setProp(get(h_fig_mol, 'Children'), 'Units', ...
                    'normalized');
                set(h_fig_mol, 'Units', 'centimeters');
                mg = 1;
                pos = [0 0 (21-2*mg) (29.7-2*mg*29.7/21)];
                set(h_fig_mol,'Position',pos, ...
                    'PaperPositionMode','manual','PaperUnits', ...
                    'centimeters','PaperSize',[pos(3)+2 pos(4)+2], ...
                    'PaperPosition',[mg mg pos(3) pos(4)]);

                switch figFmt
                    case 1 % pdf
                        fname_fig{nfig} = cat(2,pname_fig_temp, ...
                            filesep,name,'_mol',num2str(m_ind(n_prev)),...
                            '-',num2str(m),'of',num2str(nMol),'.pdf');
                        print(h_fig_mol,fname_fig{nfig},'-dpdf');
                        nfig = nfig + 1;

                    case 2 % png
                        fname_fig = [name '_mol' num2str(m_ind(n_prev)) ...
                            '-' num2str(m) 'of' num2str(nMol) '.png'];
                        fname_fig = overwriteIt(fname_fig,pname_fig,...
                            h_fig);
                        if isempty(fname_fig)
                            return;
                        end
                        print(h_fig_mol, cat(2,pname_fig,fname_fig), ...
                            '-dpng');

                    case 3 % jpg
                        fname_fig = [name '_mol' num2str(m_ind(n_prev)) '-'...
                            num2str(m) 'of' num2str(nMol) '.jpeg'];
                        fname_fig = overwriteIt(fname_fig,pname_fig,...
                            h_fig);
                        if isempty(fname_fig)
                            return;
                        end
                        print(h_fig_mol, cat(2,pname_fig,fname_fig), ...
                            '-djpeg');
                end

                delete(h_fig_mol);
                h_fig_mol = [];
                n_prev = n + 1;
                m_i = 0;
            end
        end
            
        % loading bar update-----------------------------------
        err = loading_bar('update', h_fig);
        % -----------------------------------------------------
        if err
            return;
        end
    end
    
catch err
    updateActPan(['An error occurred during processing of molecule n:°' ...
        num2str(m) ':\n' err.message], h_fig, 'error');
    for i = 1:size(err.stack,1)
        disp(['function: ' err.stack(i,1).name ', line: ' ...
            num2str(err.stack(i,1).line)]);
    end
    h = guidata(h_fig);
    if fromTT
        h.param = p;
        guidata(h_fig, h);
    end
    return
end


% added by FS, 19.3.2018
if saveTr
    if nFRET>0 && saveFact
        
        % build file name
        curs = strfind(name_mol, '_mol');
        if ~isempty(curs)
            name = name_mol(1:(curs-1));
        else
            name = name_mol;
        end
        fname_gam = cat(2,name,'.gam');
        fname_gam = overwriteIt(fname_gam,pname_xp,h_fig);
        if isempty(fname_gam)
            return
        end
        fname_bet = cat(2,name,'.bet');
        fname_bet = overwriteIt(fname_bet,pname_xp,h_fig);
        if isempty(fname_bet)
            return
        end
        
        % write data to file
        f1 = fopen(cat(2,pname_xp,fname_gam), 'Wt');
        f2 = fopen(cat(2,pname_xp,fname_bet), 'Wt');
        
        fmt = repmat('%0.3f\t',1,nFRET);
        
        fmt(end) = 'n';
        
        gammaAll(~~sum(isnan(gammaAll),2),:) = [];
        betaAll(~~sum(isnan(betaAll),2),:) = [];
        
        head = '';
        for i = 1:nFRET
            head = cat(2,head,'FRET',num2str(FRET(i,1)),'-',...
                num2str(FRET(i,2)),'\t');
        end
        head(end) = 'n';
        fprintf(f1, head);
        fprintf(f2, head);
        fprintf(f1, fmt, gammaAll');
        fprintf(f2, fmt, betaAll');
        
        fclose(f1);
        fclose(f2);
    end
end


%% Traces (complement) and build action

str = '';
if saveTr
    if ~allInOne
        if saveAscii
            % update action
            str = cat(2,str,'Intensity traces saved to ASCII files in ',...
                'folder: ',pname_ascii,'\n');
        end

        if saveTr_fret
            % update action
            str = cat(2,str,'FRET traces saved to ASCII files in folder: ',...
                pname_ascii,'\n');
        end
        
        if saveTr_S
            % update action
            str = cat(2,str,'S traces saved to ASCII files in folder: ',...
                pname_ascii,'\n');
        end
        
    elseif saveAscii
        % update action
        str = cat(2,str,'Traces saved to ASCII files in folder: ',...
            pname_ascii,'\n');
    end
    
    if fromTT && savePrm == 1 
        % update action
        str = cat(2,str,'Parameters saved to files in folder: ',pname_xp,...
            '\n');
    end
    if saveFact
        % update action
        str = cat(2,str,'Gamma and beta factors saved to files: ',...
            fname_gam,' and ',fname_bet,' in folder: ',pname_xp,'\n');
    end

    for j = 1:nFRET
        
        ext_f = cat(2,'FRET',num2str(FRET(j,1)),'to',num2str(FRET(j,2)));

        if saveSmart
            
            % build SMART file name
            fname_smart = cat(2,name,'_all',num2str(N),ext_f,...
                '_SMART.traces');
            fname_smart = overwriteIt(fname_smart,pname_smart,h_fig);
            if isempty(fname_smart)
                return;
            end
            
            % write data to SMART file
            group_data = dat_smart{j};
            for n = 1:size(group_data,2)
                group_data{n} = fname_smart;
            end
            save(cat(2,pname_smart,fname_smart),'group_data','-mat');
            
            % update action
            str = cat(2,str,'Donor and acceptor traces saved to SMART-',...
                'compatible file: ',fname_smart,' in folder: ',pname_smart,...
                '\n');
        end
        
        if saveVbfret
            
            % build vbFRET file name
            fname_vbfret = cat(2,name,'_all',num2str(N),ext_f,...
                '_vbFRET.mat');
            fname_vbfret = overwriteIt(fname_vbfret,pname_vbfret,h_fig);
            if isempty(fname_vbfret)
                return;
            end
            
            % write data to vbFRET file
            data = I_fret{j};
            save(cat(2,pname_vbfret,fname_vbfret),'data','-mat');
            
            % update action
            str = cat(2,str,'Donor and acceptor traces saved to vbFRET-',...
                'compatible file: ',fname_vbfret,' in folder: ',...
                pname_vbfret,'\n');
        end
        
        if saveEbfret
            
            % build vbFRET file name
            fname_ebfret = cat(2,name,'_all',num2str(N),ext_f,...
                '_ebFRET.dat');
            fname_ebfret = overwriteIt(fname_ebfret,pname_ebfret,h_fig);
            if isempty(fname_ebfret)
                return;
            end
            
            % write data to ebFRET file
            f = fopen(cat(2,pname_ebfret,fname_ebfret),'Wt');
            fprintf(f,'%d\t%d\t%d\n',data_ebfret{j}');
            fclose(f);
            
            % update action
            str = cat(2,str,'Donor and acceptor traces saved to ebFRET-',...
                'compatible file: ',fname_ebfret,' in folder: ',...
                pname_ebfret,'\n');
        end
    end
    
    if saveHa
        % update action
        str = cat(2,str,'Donor and acceptor traces saved to HaMMy-',...
            'compatible files in folder: ',pname_ha,'\n');
    end
    if saveQub
        % update action
        str = cat(2,str,'Donor and acceptor traces saved to QUB-',...
            'compatible files in folder: ',pname_qub,'\n');
    end
end
    
if saveHist
    if saveHst_I
        if inclDiscr && discrInt
            str = cat(2,str,'Intensity and discrete intensity ',...
                'histograms saved to ASCII files  in folder: ',...
                pname_hist,'\n');
        else
            str = cat(2,str,'Intensity histograms saved to ASCII ',...
                'files  in folder: ',pname_hist,'\n');
        end
    end

    if saveHst_fret
        % update action
        if inclDiscr
            str = cat(2,str,'FRET and discrete FRET histograms saved ', ...
                'to ASCII files in folder: ',pname_hist,'\n');
        else
            str = cat(2,str,'FRET histograms saved to ASCII files in ',...
                'folder: ',pname_hist,'\n');
        end
    end
    if saveHst_S
        % update action
        if inclDiscr
            str = cat(2,str,'Stoichiometry and discrete Stoichiometry',...
                'histograms saved to ASCII files in folder: ',...
                pname_hist,'\n');
        else
            str = cat(2,str,'Stoichiometry histograms saved to ASCII ',...
                'files in folder: ',pname_hist,'\n');
        end
    end
end

if saveDt
    if saveDt_I
        % update action
        str = cat(2,str,'Intensity dwell times saved to ASCII files in',...
            'folder: ',pname_dt,'\n');
    end
    if saveKin && discrInt
        % update action
        str = cat(2,str,'Intensity dynamics statistics saved to file: ', ...
            fname_kinI,'in folder: ',pname_dt,'\n');
    end
    if saveDt_fret
        % update action
        str = cat(2,str,'FRET dwell times saved to ASCII files in ',...
            'folder: ',pname_dt,'\n');
    end
    if saveKin && nFRET>1
        % update action
        str = cat(2,str,'FRET dynamics statistics saved to file: ', ...
            fname_kinF,'in folder: ',pname_dt,'\n');
    end
    if saveDt_S
        % update action
        str = cat(2,str,'Stoichiometry dwell times saved to ASCII files ',...
            'in folder: ',pname_dt,'\n');
    end
    if saveKin && nS>1
        % update action
        str = cat(2,str,'Stoichiometry dynamics statistics saved to file: ', ...
            fname_kinS,'in folder: ',pname_dt,'\n');
    end
end

%% Figure complement
if saveFig && figFmt == 1 % *.pdf
    
    % build file name
    fname_pdf = cat(2,name,'_all',num2str(N),'.pdf');
    fname_pdf = overwriteIt(fname_pdf,pname_fig,h_fig);
    if isempty(fname_pdf)
        return
    end
    
    % delete existing file to not append figures
    if exist(cat(2,pname_fig,fname_pdf),'file');
        delete(cat(2,pname_fig,fname_pdf));
    end
    
    % write data to file
    append_pdfs(cat(2,pname_fig,fname_pdf), fname_fig{:});
    
    % delete temporary files
    flist = dir(pname_fig_temp);
    for i = 1:size(flist,1)
        if ~(strcmp(flist(i).name,'.') || strcmp(flist(i).name,'..')) 
            delete(cat(2,pname_fig_temp,filesep,flist(i).name));
        end
    end
    rmdir(pname_fig_temp);
    
    % update action
    str = cat(2,str,'Figures saved to file: ',fname_pdf,' in folder: ',...
        pname_fig,'\n');
    
elseif saveFig
    % update action
    str = cat(2,str,'Figures saved to files in folder: ',pname_fig,'\n');
end

loading_bar('close', h_fig);

if fromTT
    h = guidata(h_fig);
    h.param = p;
    guidata(h_fig, h);
end

str = str(1:end-2); % remove last '\n'
setContPan(cat(2,'Export completed:\n',str),'success',h_fig);


function upgradeKinFile(fname_kin,fname_dt,kinDat)

if exist(fname_kin,'file')
    f = fopen(fname_kin, 'r');
    fgetl(f); % skip headers
    fData = textscan(f,'%s','delimiter','\n');
    fData = fData{1,1};
    fclose(f);

    fDataNew = {};
    if ~isempty(fData)
        for j = 1:size(fData,1)
            existDat = strfind(fData{j,1},fname_dt);
            if isempty(existDat)
                fDataNew = [fDataNew; fData{j,1}];
            end
        end
    end
    
    f = fopen(fname_kin,'Wt');
    fprintf(f,cat(2,'file name\tstate1\tstate2\ttotal time spent in 1\t',...
        'total time spent in 2\taverage time in 1\taverage time in 2\t',...
        'ratio average time 1/2\n'));
    if ~isempty(fDataNew)
        for j = 1:size(fDataNew,1)
            fprintf(f, [fDataNew{j,1} '\n']);
        end
    end
    fclose(f);
    
else
    f = fopen(fname_kin, 'Wt');
    fprintf(f,cat(2,'file name\tstate1\tstate2\ttotal time spent in 1\t',...
        'total time spent in 2\taverage time in 1\taverage time in 2\t',...
        'ratio average time 1/2\n'));
    fclose(f);
end

f = fopen(fname_kin, 'At');
for i = 1:size(kinDat,1)
    fprintf(f,'%s',fname_dt);
    fprintf(f,cat(2,repmat('\t%d',[1,size(kinDat,2)]),'\n'),kinDat(i,:));
end
fclose(f);






