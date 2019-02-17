function saveProcAscii(h_fig, p, xp, pname, name)

h = guidata(h_fig);

% saveProcAscii is/isn't called from trace processing export window
% (openExpTtpr.m)--> can be called in a routine:
fromTT = isequalwithequalnans(p, h.param.ttPr);

%% collect project parameters

proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nMol = size(p.proj{proj}.intensities,2)/nChan;
coord = p.proj{proj}.coord;
if fromTT && xp.mol_valid
    mol_incl = p.proj{proj}.coord_incl;
else
    mol_incl = true(1,nMol);
end

% added by FS, 24.4.2018
mol_TagVal = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.mol_TagVal;
if mol_TagVal > length(p.proj{proj}.molTagNames)
    mol_incl_tag = mol_incl;
else
    mol_incl_tag = p.proj{proj}.molTag == mol_TagVal;
end

exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
labels = p.proj{proj}.labels;

if isfield(p.proj{proj},'fix')
    perSec = p.proj{proj}.fix{2}(4);
    perPix = p.proj{proj}.fix{2}(5);
else
    perSec = 0;
    perPix = 1;
end
nPix = p.proj{proj}.pix_intgr(2);
rate = p.proj{proj}.frame_rate; % this is the EXPOSURE TIME

FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
%N = numel(find(mol_incl));
N = numel(find(mol_incl & mol_incl_tag)); % added by FS, 24.4. 2018
nFRET = size(FRET,1);
nS = size(S,1);
nExc = numel(exc);

intensities = p.proj{proj}.intensities_denoise;
if fromTT
    intensities_DTA = p.proj{proj}.intensities_DTA;
else
    intensities_DTA = p.proj{proj}.adj.intensities_DTA;
end

iunits = 'counts';
if perSec
    iunits = cat(2,iunits,'/second');
    intensities = intensities/rate;
    intensities_DTA = intensities_DTA/rate;
end
if perPix
    iunits = cat(2,iunits,'/pixel');
    intensities = intensities/nPix;
    intensities_DTA = intensities_DTA/nPix;
end

if fromTT
    FRET_DTA = p.proj{proj}.FRET_DTA;
    S_DTA = p.proj{proj}.S_DTA;
else
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
        pname_vbfret = setCorrectPath(cat(2,pname,'traces_VbFRET'), h_fig);
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
    saveTr_I = xp.traces{2}(1);
    saveTr_fret = ~~xp.traces{2}(2) & nFRET > 0;
    saveTr_S = ~~xp.traces{2}(3) & nS > 0;
    allInOne = ~~xp.traces{2}(4);
    savePrm = xp.traces{2}(5); % external file/in trace file/none
    saveGam = xp.traces{2}(6);  % added by FS, 19.3.2018
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
    if perSec
        minI = minI/rate;
        binI = binI/rate;
        maxI = maxI/rate;
    end
    if perPix
        minI = minI/nPix;
        binI = binI/nPix;
        maxI = maxI/nPix;
    end
    
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
end
saveKin = xp.dt{2}(4);
if saveKin
    fname_kinI = [name '_I.kin'];
    fname_kinF = [name '_FRET.kin'];
    fname_kinS = [name '_S.kin'];
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
        updateActPan('No molecules with the specified tag are found', h_fig, 'error');
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

% loading bar parameters---------------------------------------------------
err = loading_bar('init', h_fig , nMol, ...
    'Export process data for selected molecules ...');
if err
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% -------------------------------------------------------------------------

gammaAll = NaN(nMol,nFRET);  % added by FS, 19.3.2018
n = 0;
try
    for m = 1:nMol
        if mol_incl(m) && mol_incl_tag(m)  % added by FS, 24.4.2018
            
            % increment number of exported molecules
            n = n + 1;
            
            % display action
            str = cat(2,'export data of molecule n:°',num2str(m),'(',...
                num2str(n),' on ',num2str(N),'):');
            
            % if requested, process molecule data before exporting
            if fromTT && xp.process
                
                % process data
                p = updateTraces(h_fig, 'ttPr', m, p, []);
                
                % collect processed data
                intensities = p.proj{proj}.intensities_denoise;
                intensities_DTA = p.proj{proj}.intensities_DTA;
                FRET_DTA = p.proj{proj}.FRET_DTA;
                S_DTA = p.proj{proj}.S_DTA;
                
                % convert intensity to proper units
                if perSec
                    intensities = intensities/rate;
                    intensities_DTA = intensities_DTA/rate;
                end
                if perPix
                    intensities = intensities/nPix;
                    intensities_DTA = intensities_DTA/nPix;
                end
                
            end
            
            % build frame and time column
            incl = p.proj{proj}.bool_intensities(:,m);
            [frames,o,o] = find(incl);
            frames = ((nExc*(frames(1)-1)+1):nExc*frames(end))';
            times = frames*rate;
            
            % build molecule file name
            name_mol = [name '_mol' num2str(n) 'of' num2str(N)];
            
            % intensity traces are/aren't discretized
            if fromTT
                discrInt = ~p.proj{proj}.prm{m}{4}{1}(2) || ...
                    p.proj{proj}.prm{m}{4}{1}(2)==2;
            else
                discrInt = 1;
            end
            
            % select molecule intensity data
            int_m = intensities(incl,((m-1)*nChan+1):m*nChan,:);
            intDTA_m = intensities_DTA(incl,((m-1)*nChan+1):m*nChan,:);
            
            % format molecule processing parameters
            if fromTT && saveTr && (savePrm<3) % save parameters
                str_xp = getStrPrm(p.proj{proj}, m, h_fig);
            end

            %% export traces

            if saveTr
                if saveAscii
                    % initialize data to write in file
                    head_I = [];    fmt_I = [];    dat_I = [];
                    head_fret = []; fmt_fret = []; dat_fret = [];
                    head_s = [];    fmt_s = [];    dat_s = [];
                    
                    if saveTr_I
                        % format intensity data
                        [head_I,fmt_I,dat_I] = formatInt2File(exc, ...
                            [times,frames],cat(2,int_m,intDTA_m),iunits,...
                            discrInt);
                        
                        if ~allInOne
                            % write data to intensity file
                            [name_mol,name] = writeDat2file(cat(2,...
                                pname_ascii,name_mol),'_I.txt',[n,N],...
                                {head_I,fmt_I,dat_I},[fromTT,savePrm],...
                                str_xp,h_fig);
                            if isempty(name)
                                return;
                            end
                            
                            % update action
                            str = cat(2,str,'\nIntensity traces saved',...
                                ' to ASCII file: ',name_mol,'_I.txt',...
                                '\n in folder: ',pname_ascii);
                        end
                    end
                    
                    if saveTr_fret
                        % calculate FRET
                        if fromTT
                            gamma = p.proj{proj}.prm{m}{5}{3};
                        else
                            gamma = 1;
                        end
                        FRET_all = calcFRET(nChan,nExc,exc,chanExc,FRET,...
                            int_m,gamma);
                        FRET_DTA_all = FRET_DTA(incl,(m-1)*nFRET+1:m*nFRET);
                        
                        % format FRET data
                        [head_fret,fmt_fret,dat_fret] = formatFret2File(...
                            exc,chanExc,[times,frames],cat(2,FRET_all,...
                            FRET_DTA_all),FRET);

                        if ~allInOne
                            % write data to FRET file
                            [name_mol,name] = writeDat2file(cat(2,...
                                pname_ascii,name_mol),'_FRET.txt',[n,N],...
                                {head_fret,fmt_fret,dat_fret},[fromTT,...
                                savePrm],str_xp,h_fig);
                            if isempty(name)
                                return;
                            end
                            
                            % update action
                            str = cat(2,str,'\nFRET traces saved to ',...
                                'ASCII file: ',name_mol,'_FRET.txt',...
                                '\n in folder: ',pname_ascii);
                        end
                    end
                    
                    if saveTr_S
                        % format stoichiometry data
                        [head_s,fmt_s,dat_s] = formatS2File(exc,chanExc,...
                            [times,frames],int_m,...
                            S_DTA(incl,(m-1)*nS+1:m*nS),labels,S);
                        
                        if ~allInOne
                            % write data to stoichiometry file
                            [name_mol,name] = writeDat2file(cat(2,...
                                pname_ascii,name_mol),'_S.txt',[n,N],...
                                {head_s,fmt_s,dat_s},[fromTT,savePrm],...
                                str_xp,h_fig);
                            if isempty(name)
                                return;
                            end
                            
                            % update action
                            str = cat(2,str,'\nS traces saved to ASCII',...
                                ' file: ',name_mol,'_S.txt\n in folder: ',...
                                pname_ascii);
                        end
                    end
                    
                    if allInOne
                        % write data in molecule file
                        [name_mol,name] = writeDat2file(cat(2,...
                            pname_ascii,name_mol),'.txt',[n,N],...
                            {head_I,fmt_I,dat_I;head_fret,fmt_fret,...
                            dat_fret;head_s,fmt_s,dat_s},...
                            [fromTT,savePrm],str_xp,h_fig);
                        if isempty(name)
                            return;
                        end
                        
                        % update action
                        str = cat(2,str,'\nTraces saved to ASCII ',...
                            'file: ',name_mol,'.txt\n in folder: ',...
                            pname_ascii);
                    end
                end
                
                % save traces compatible with external software
                if saveHa||saveVbfret||saveSmart||saveEbfret||saveQub
                    
                    for j = 1:nFRET
                        % format intensity data for FRET calculation
                        ext_f = cat(2,'FRET',num2str(FRET(j,1)),'to', ...
                            num2str(FRET(j,2)));
                        [o,l,o] = find(exc==chanExc(FRET(j,1)));
                        I_fret{j}{n} = intensities(incl,[(m-1)*nChan+FRET(j,1), ...
                            (m-1)*nChan+FRET(j,2)],l);

                        if saveHa
                            % format HaMMy data
                            [head,fmt,dat] = formatHa2File(...
                                times(l:nExc:end,1),I_fret{j}{n});

                            % write data to HaMMy file
                            [name_mol,name] = writeDat2file(cat(2,...
                                pname_ha,name_mol),cat(2,ext_f,...
                                '_HaMMy.dat'),[n,N],{head,fmt,dat},...
                                [fromTT,0],'',h_fig);
                            if isempty(name)
                                return;
                            end
                            
                            % update action
                            str = cat(2,str,'\nTraces (',ext_f,') ',...
                                'saved to HaMMy-compatible file: ',...
                                name_mol,ext_f,'_HaMMy.dat\n in folder: ',...
                                pname_ha);
                        end

                        if saveSmart
                            % format SMART data
                            if ~p.proj{proj}.is_coord
                                dat_smart{j} = formatSmart2File(...
                                    I_fret{j}{n},[n,N],rate*nExc,zeros(...
                                    numel(mol_incl),numel(2*FRET(j,1)-1:...
                                    2*FRET(j,1))));
                            else
                                dat_smart{j} = formatSmart2File(...
                                    I_fret{j}{n},[n,N],rate*nExc,coord(...
                                    mol_incl,(2*FRET(j,1)-1):2*FRET(j,1)));
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
                            [name_mol,name] = writeDat2file(cat(2,...
                                pname_qub,name_mol),cat(2,ext_f,...
                                '_QUB.txt'),[n,N],{head,fmt,dat},...
                                [fromTT,0],'',h_fig);
                            if isempty(name)
                                return;
                            end
                            
                            % update action
                            str = cat(2,str,'\nTraces (',ext_f,') ',...
                                'saved to QUB-compatible file: ',...
                                name_mol,ext_f,'_QUB.txt in folder: ',...
                                pname_qub);
                        end
                    end
                end
                
                % save parameters
                if fromTT && savePrm == 1 
                    
                    % write parameters to file
                    [name_mol,name] = writeDat2file(...
                        cat(2,pname_xp,name_mol),'.log',[n,N],...
                        {'',str_xp,[]},[fromTT,0],'',h_fig);
                    if isempty(name)
                        return;
                    end
                    
                    % update action
                    str = cat(2,str,'\nParameters saved to file: ',...
                        name_mol,'.log\n in folder: ',pname_xp);
                end
                
                % format gamma factor data
                % added by FS, 19.3.2018
                if saveGam
                    for i = 1:nFRET
                        if fromTT
                            gammaAll(m,i) = p.proj{proj}.prm{m}{5}{3}(i);
                        else
                            gammaAll(m,i) = 1;
                        end
                    end
                end
            end


            %% histograms

            if saveHist
                if saveHst_I
                    
                    x_I = minI:binI:maxI;
                    
                    for l = 1:nExc
                        for c = 1:nChan
                            
                            % format intensity histogram data
                            I = intensities(incl,(m-1)*nChan+c,l);
                            histI = [];
                            histI(:,1) = x_I';
                            histI(:,2) = (hist(I,x_I))';
                            histI(:,3) = histI(:,2)/sum(histI(:,2));
                            histI(:,4) = cumsum(histI(:,2));
                            histI(:,5) = histI(:,4)/histI(end,4);
                            
                            % build file name
                            fname_histI = cat(2,name_mol,'_I',num2str(c),...
                                '-',num2str(exc(l)),'.hist');
                            [name_mol,name] = correctNamemol(fname_histI,...
                                pname_hist,[n,N],h_fig);
                            if isempty(name)
                                return;
                            end
                            fname_histI = cat(2,name_mol,'_I',num2str(c),...
                                '-',num2str(exc(l)),'.hist');
                            
                            % write data to file
                            f = fopen(cat(2,pname_hist,fname_histI),'Wt');
                            fprintf(f,cat(2,'I',num2str(c),'-', ...
                                num2str(exc(l)),'\tfrequency count\t',...
                                'probability\tcumulative frequency ',...
                                'count\tcumulative probability\n'));
                            fprintf(f,cat(2,repmat('%d\t',...
                                [1,size(histI,2)]),'\n'),histI');
                            fclose(f);
                            
                            % display action
                            str = cat(2,str,'\nIntensity(channel ',...
                                num2str(c),', ',num2str(exc(l)),...
                                'nm) histograms saved to ASCII file: ', ...
                                fname_histI,'\n in folder: ',pname_hist);
                            
                            if inclDiscr && discrInt
                                % format discrete intensity histogram
                                discrI = ...
                                    intensities_DTA(incl,(m-1)*nChan+c,l);
                                histdI = [];
                                histdI(:,1) = x_I';
                                histdI(:,2) = (hist(discrI,x_I))';
                                histdI(:,3) = ...
                                    histdI(:,2)/sum(histdI(:,2));
                                histdI(:,4) = cumsum(histdI(:,2));
                                histdI(:,5) = histdI(:,4)/histdI(end,4);
                                
                                % build file name
                                [o,fname_histdI,o] = fileparts(fname_histI);
                                fname_histdI = cat(2,fname_histdI,...
                                    '_discr.hist');
                                
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
                                
                                % update action
                                str = cat(2,str,'\nDiscretised intensity', ...
                                    '(channel ',num2str(c),', ',...
                                    num2str(exc(l)),'nm) histograms ', ...
                                    'saved to ASCII file: ', ...
                                    fname_histdI,'\n in folder: ', ...
                                    pname_hist);
                            end
                        end
                    end
                end
                
                if saveHst_fret
                    
                    x_fret = minFret:binFret:maxFret;
                    
                    % calculate FRET data
                    if fromTT
                        gamma = p.proj{proj}.prm{m}{5}{3};
                    else
                        gamma = 1;
                    end
                    FRET_all = calcFRET(nChan, nExc, exc, chanExc,FRET, ...
                        intensities(incl,(((m-1)*nChan+1):m*nChan),:), gamma);
                    
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
                        [name_mol,name] = correctNamemol(fname_histF,...
                                pname_hist,[n,N],h_fig);
                        if isempty(name)
                            return;
                        end
                        fname_histF = cat(2,name_mol,'_FRET',...
                            num2str(FRET(i,1)),'to',num2str(FRET(i,2)),...
                            '.hist');
                        
                        % write data to file
                        f = fopen(cat(2,pname_hist,fname_histF),'Wt');
                        fprintf(f,cat(2,'FRET\tfrequency count\t',...
                            'probability\tcumulative frequency count\t',...
                            'cumulative probability\n'));
                        fprintf(f,cat(2,repmat('%d\t',[1,size(histF,2)]),...
                            '\n'),histF');
                        fclose(f);
                        
                        % update action
                        str = cat(2,str,'\nFRET (',num2str(FRET(i,1)),...
                            ' to ',num2str(FRET(i,2)),') histograms saved ',...
                            'to ASCII file: ',fname_histF,'\n in folder: ', ...
                            pname_hist);
                        
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
                            [o,fname_histdF,o] = fileparts(fname_histF);
                            fname_histdF = cat(2,fname_histdF,...
                                '_discr.hist');
                            
                            % write data to file
                            f = fopen(cat(2,pname_hist,fname_histdF),'Wt');
                            fprintf(f,cat(2,'discr.FRET\tfrequency count',...
                                '\tprobability\tcumulative frequency ',...
                                'count\tcumulative probability\n'));
                            fprintf(f,cat(2,repmat('%d\t',...
                                [1,size(histdF,2)]),'\n'),histdF');
                            fclose(f);
                            
                            % update action
                            str = cat(2,str,'\nDiscretised FRET (',...
                                num2str(FRET(i,1)),' to ',...
                                num2str(FRET(i,2)),') histograms saved', ...
                                'to ASCII file: ',fname_histdF,...
                                '\nin folder: ',pname_hist);
                        end
                    end
                end
                
                if saveHst_S
                    
                    x_s = minS:binS:maxS;
                    
                    for i = 1:nS
                        % calculate stoichiometry data
                        [o,l_s,o] = find(exc==chanExc(S(i)));
                        Inum = sum(intensities(incl,((m-1)*nChan+1): ...
                            m*nChan,l_s),2);
                        Iden = sum(sum(intensities(incl,((m-1)*nChan+1): ...
                            m*nChan,:),2),3);
                        S_tr = Inum./Iden;
                        
                        % format stoichiometry histogram
                        histS = [];
                        histS(:,1) = x_s';
                        histS(:,2) = (hist(S_tr,x_s))';
                        histS(:,3) = histS(:,2)/sum(histS(:,2));
                        histS(:,4) = cumsum(histS(:,2));
                        histS(:,5) = histS(:,4)/histS(end,4);
                        
                        % build file name
                        fname_histS = cat(2,name_mol,'_S',labels{S(i)},...
                            '.hist');
                        [name_mol,name] = correctNamemol(fname_histS,...
                                pname_hist,[n,N],h_fig);
                        if isempty(name)
                            return;
                        end
                        fname_histS = cat(2,name_mol,'_S',labels{S(i)},...
                            '.hist');
                       
                        % write data to file
                        f = fopen(cat(2,pname_hist,fname_histS),'Wt');
                        fprintf(f,cat(2,'S\tfrequency count\tprobability',...
                            '\tcumulative frequency count\tcumulative ',...
                            'probability\n'));
                        fprintf(f,cat(2,repmat('%d\t',[1,size(histS,2)]),...
                            '\n'),histS');
                        fclose(f);
                            
                        % update action
                        str = cat(2,str,'\nStoichiometry (',labels{S(i)}, ...
                            ') histograms saved to ASCII file: ', ...
                            fname_histS,'\n in folder: ',pname_hist);

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
                            [o,fname_histdS,o] = fileparts(fname_histS);
                            fname_histdS = cat(2,fname_histdS,...
                                '_discr.hist');
                            
                            % write data to file
                            f = fopen(cat(2,pname_hist,fname_histdS),'Wt');
                            fprintf(f,cat(2,'discr.S\tfrequency count\t',...
                                'probability\tcumulative frequency count',...
                                '\tcumulative probability\n'));
                            fprintf(f,cat(2,repmat('%d\t',...
                                [1,size(histdS,2)]),'\n'),histdS');
                            fclose(f);
                            
                            % update action
                            str = cat(2,str,'\nDiscretised Stoichiometry ',...
                                '(',labels{S(i)},') histograms saved to ',...
                                'ASCII file: ',fname_histdS,'\n in ',...
                                'folder: ',pname_hist);
                        end
                    end
                end
            end

            %% Dwell-times

            if saveDt
                if (saveDt_I  || saveKin) && discrInt
                    for l = 1:nExc
                        for c = 1:nChan
                            
                            % format intensity dwell times
                            discr_I = ...
                                intensities_DTA(incl,(m-1)*nChan+c,l);
                            dtI = getDtFromDiscr(discr_I, rate);
                            
                            % build file name
                            fname_dtI = cat(2,name_mol,'_I',num2str(c),...
                                '-',num2str(exc(l)),'.dt');
                            [name_mol,name] = correctNamemol(fname_dtI,...
                                pname_dt,[n,N],h_fig);
                            fname_dtI = cat(2,name_mol,'_I',num2str(c),...
                                '-',num2str(exc(l)),'.dt');
                            
                            % write data to file
                            if saveDt_I
                                f = fopen(cat(2,pname_dt,fname_dtI),'Wt');
                                fprintf(f,cat(2,'dwell time (second)\t',...
                                    'I before\tI after\n'));
                                fprintf(f,cat(2,repmat('%d\t',...
                                    [1,size(dtI,2)]),'\n'),dtI');
                                fclose(f);
                            end
                            
                            % update action
                            str = cat(2,str,'\nIntensity(channel ',...
                                num2str(c),', ',num2str(exc(l)),...
                                'nm) dwell times saved to ASCII file: ', ...
                                fname_dtI,'\n in folder: ',pname_dt);
                            
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
                        dtF = getDtFromDiscr(discr_F, rate);
                        
                        % build file name
                        fname_dtF = cat(2,name_mol,'_FRET',num2str(...
                            FRET(i,1)),'to',num2str(FRET(i,2)),'.dt');
                        [name_mol,name] = correctNamemol(fname_dtF,...
                                pname_dt,[n,N],h_fig);
                        fname_dtF = cat(2,name_mol,'_FRET',num2str(...
                            FRET(i,1)),'to',num2str(FRET(i,2)),'.dt');
                               
                        % write data to file
                        if saveDt_fret
                            f = fopen(cat(2,pname_dt,fname_dtF),'Wt');
                            fprintf(f,cat(2,'dwell time (second)\t',...
                                'FRET before\tFRET after\n'));
                            fprintf(f,cat(2,repmat('%d\t',...
                                [1,size(dtF,2)]),'\n'),dtF');
                            fclose(f);
                        end

                        % update action
                        str = cat(2,str,'\nFRET (',num2str(FRET(i,1)),...
                            ' to ',num2str(FRET(i,2)),') dwell times',...
                            ' saved to ASCII file: ',fname_dtF,...
                            '\nin folder: ',pname_dt);

                        if saveKin && size(dtF,1)>1 && ...
                                numel(unique(dtF(:,2:3)))<=6
                            kinDat = getKinDat(dtF);
                            upgradeKinFile(cat(2,pname_dt,fname_kinF), ...
                                fname_dtF, kinDat)
                        end
                    end
                end
                if saveDt_S || saveKin
                    for i = 1:nS
                        
                        % format stoichiometry dwell times
                        discr_S = S_DTA(incl,(m-1)*nS+i);
                        dtS = getDtFromDiscr(discr_S, rate);
                        
                        % build file name
                        fname_dtS = cat(2,name_mol,'_S',labels{S(i)},...
                            '.dt');
                        [name_mol,name] = correctNamemol(fname_dtS,...
                            pname_dt,[n,N],h_fig);
                        fname_dtS = cat(2,name_mol,'_S',labels{S(i)},...
                            '.dt');
                        
                        % write data to file
                        if saveDt_S
                            f = fopen(cat(2,pname_dt,fname_dtS),'Wt');
                            fprintf(f,cat(2,'dwell time (second)\t',...
                                'S before\tS after\n'));
                            fprintf(f,cat(2,repmat('%d\t',...
                                [1,size(dtS,2)]),'\n'),dtS');
                            fclose(f);
                        end
                        
                        % update action
                        str = cat(2,str,'\nStoichiometry (',labels{S(i)}, ...
                            ') dwell times saved to ASCII file: ', ...
                            fname_dtS,'\n in folder: ',pname_dt);
                        
                        if saveKin && size(dtS,1)>1 && ...
                                numel(unique(dtS(:,2:3)))<=6
                            kinDat = getKinDat(dtS);
                            upgradeKinFile(cat(2,pname_dt,fname_kinS), ...
                                fname_dtS, kinDat)
                        end
                    end
                end
            end

            %% Figures
            if saveFig
                if m == m_start
                    h_fig_mol = [];
                    [o,i_m,o] = find(m_ind == m);
                    min_end = min([(i_m+molPerFig-1) numel(m_ind)]);
                    m_max = m_ind(min_end);
                    n_prev = n;
                    m_i = 0;
                end

                m_i = m_i+1;
                
                p2 = p;
                if ~fromTT
                    if isfield(p.proj{proj},'prmTT')
                        p2.proj{proj}.prm = p.proj{proj}.prmTT;
                    end
                    p2.proj{proj}.intensities_DTA = ...
                        p2.proj{proj}.adj.intensities_DTA;
                    p2.proj{proj}.FRET_DTA = ...
                        p2.proj{proj}.adj.FRET_DTA;
                    p2.proj{proj}.S_DTA = p2.proj{proj}.adj.S_DTA;
                end

                h_fig_mol = buildFig(p2, m, m_i, n, molPerFig, p_fig, ...
                    h_fig_mol);

                if m == m_max || m == m_end
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
                                filesep,name,'_mol',num2str(n_prev),'-', ...
                                num2str(n),'of',num2str(N),'.pdf');
                            print(h_fig_mol,fname_fig{nfig},'-dpdf');
                            nfig = nfig + 1;

                        case 2 % png
                            fname_fig = [name '_mol' num2str(n_prev) ...
                                '-' num2str(n) 'of' num2str(N) '.png'];
                            print(h_fig_mol, [pname_fig fname_fig], ...
                                '-dpng');

                        case 3 % jpg
                            fname_fig = [name '_mol' num2str(n_prev) '-'...
                                num2str(n) 'of' num2str(N) '.jpeg'];
                            print(h_fig_mol, [pname_fig fname_fig], ...
                                '-djpeg');
                    end

                    delete(h_fig_mol);
                    h_fig_mol = [];
                    [o,i_m,o] = find(m_ind == m);
                    min_end = min([(i_m+molPerFig) numel(m_ind)]);
                    m_max = m_ind(min_end);
                    n_prev = n + 1;
                    m_i = 0;
                end
            end
            updateActPan(str, h_fig, 'process');
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
    disp(err.message);
    for i = 1:size(err.stack,1)
        disp(['function: ' err.stack(i,1).name ', line: ' ...
            num2str(err.stack(i,1).line)]);
    end
    h = guidata(h_fig);
    if fromTT
        h.param.ttPr = p;
        guidata(h_fig, h);
    end
    return;
end


% added by FS, 19.3.2018
if saveTr
    if saveGam
        curs = strfind(name_mol, '_mol');
        if ~isempty(curs)
            name = name_mol(1:(curs-1));
        else
            name = name_mol;
        end
        f = fopen([pname_xp name '.gam'], 'Wt');
        fmt = repmat('%0.3f\t', nFRET);
        fmt(end) = 'n';
        gammaAll(isnan(gammaAll)) = [];
        fprintf(f, fmt, gammaAll);
        fclose(f);
    end
end


%% Traces (complement)

if saveTr
    for j = 1:nFRET
        
        ext_f = cat(2,'FRET',num2str(FRET(j,1)),'to',num2str(FRET(j,2)));
        
        if saveSmart
            
            % build SMART file name
            fname_smart = cat(2,name,'_all',num2str(N),ext_f,...
                '_SMART.traces');
            [name_all,name] = correctNameall(fname_smart,pname_smart,N,...
                h_fig);
            fname_smart = cat(2,name_all,ext_f,'_SMART.traces');
            
            % write data to SMART file
            group_data = dat_smart{j};
            for n = 1:size(group_data,2)
                group_data{n} = fname_smart;
            end
            save(cat(2,pname_smart,fname_smart),'group_data','-mat');
            
            % update action
            updateActPan(cat(2,'Traces (',ext_f,') saved to ', ...
                'SMART-compatible file: ',fname_smart,'\n in ', ...
                'folder: ',pname_smart),h_fig,'process');
        end
        
        if saveVbfret
            
            % build vbFRET file name
            fname_vbfret = cat(2,name,'_all',num2str(N),ext_f,...
                '_vbFRET.mat');
            [name_all,name] = correctNameall(fname_vbfret,pname_vbfret,N,...
                h_fig);
            fname_vbfret = cat(2,name_all,ext_f,'_vbFRET.mat');
            
            % write data to vbFRET file
            data = I_fret{j};
            save(cat(2,pname_vbfret,fname_vbfret),'data','-mat');
            
            % update action
            updateActPan(cat(2,'Traces (',ext_f,') saved to ',...
                'VbFRET-compatible file: ',fname_vbfret,'\n in ',...
                'folder: ',pname_vbfret),h_fig,'process');
        end
        
        if saveEbfret
            
            % build vbFRET file name
            fname_ebfret = cat(2,name,'_all',num2str(N),ext_f,...
                '_ebFRET.dat');
            [name_all,name] = correctNameall(fname_ebfret,pname_ebfret,N,...
                h_fig);
            fname_ebfret = cat(2,name_all,ext_f,'_ebFRET.dat');
            
            % write data to ebFRET file
            f = fopen(cat(2,pname_ebfret,fname_ebfret),'Wt');
            fprintf(f,'%d\t%d\t%d\n',data_ebfret{j}');
            fclose(f);
            
            % update action
            updateActPan(cat(2,'Traces (',ext_f,') saved to ', ...
                'ebFRET-compatible file: ',fname_ebfret,'\n in ', ...
                'folder: ',pname_ebfret),h_fig,'process');
        end
    end
end

%% Figure complement
if saveFig && figFmt == 1 % *.pdf
    fname_pdf = cat(2,name,'_all',num2str(N),'.pdf');
    append_pdfs(cat(2,pname_fig,fname_pdf), fname_fig{:});
    flist = dir(pname_fig_temp);
    for i = 1:size(flist,1)
        if ~(strcmp(flist(i).name,'.') || strcmp(flist(i).name,'..')) 
            delete(cat(2,pname_fig_temp,filesep,flist(i).name));
        end
    end
    rmdir(pname_fig_temp);
end

loading_bar('close', h_fig);

if fromTT
    h = guidata(h_fig);
    h.param.ttPr = p;
    guidata(h_fig, h);
end



function upgradeKinFile(fname_kin, fname_dt, kinDat)

if exist(fname_kin, 'file')

    f = fopen(fname_kin, 'r');
    fData = textscan(f,'%s','delimiter','\n');
    fData = fData{1,1};
    fclose(f);

    fDataNew = {};
    if ~isempty(fData)
        for j = 1:size(fData,1)
            existDat = strfind(fData{j,1}, fname_dt);
            if isempty(existDat)
                fDataNew = [fDataNew; fData{j,1}];
            end
        end
    end
    
    f = fopen(fname_kin, 'Wt');
    if ~isempty(fDataNew)
        for j = 1:size(fDataNew,1)
            fprintf(f, [fDataNew{j,1} '\n']);
        end
    end
    fclose(f);
end

f = fopen(fname_kin, 'At');
for i = 1:size(kinDat,1)
    fprintf(f, '%s', fname_dt);
    fprintf(f, [repmat('\t%d', [1,size(kinDat,2)]) '\n'], kinDat(i,:));
end
fclose(f);






