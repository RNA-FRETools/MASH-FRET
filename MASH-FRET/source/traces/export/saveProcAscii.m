function saveProcAscii(h_fig, p, xp, pname, name)

h = guidata(h_fig);
fromTT = isequalwithequalnans(p, h.param.ttPr);

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
if perSec
    intensities = intensities/rate;
    intensities_DTA = intensities_DTA/rate;
end
if perPix
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


%% traces
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
        pname_ascii = setCorrectPath([pname 'traces_ASCII'], h_fig);
    end
    if sum(double(xp.traces{1}(2) == [2 7])) && nFRET > 0
        saveHa = true; % one file/mol
        pname_ha = setCorrectPath([pname 'traces_HaMMy'], h_fig);
    end
    if sum(double(xp.traces{1}(2) == [3 7])) && nFRET > 0
        saveVbfret = true; % all mol in one file
        pname_vbfret = setCorrectPath([pname 'traces_VbFRET'], h_fig);
    end
    if sum(double(xp.traces{1}(2) == [4 7])) && nFRET > 0
        saveSmart = true; % all mol in one file
        pname_smart = setCorrectPath([pname 'traces_SMART'], h_fig);
    end
    if sum(double(xp.traces{1}(2) == [5 7])) && nFRET > 0
        saveQub = true; % one file/mol
        pname_qub = setCorrectPath([pname 'traces_QUB'], h_fig);
    end
    if sum(double(xp.traces{1}(2) == [6 7])) && nFRET > 0
        saveEbfret = true; % one file/mol
        data_ebfret = cell(1,nFRET);
        pname_ebfret = setCorrectPath([pname 'traces_ebFRET'], h_fig);
    end
    saveTr_I = xp.traces{2}(1);
    saveTr_fret = ~~xp.traces{2}(2) & nFRET > 0;
    saveTr_S = ~~xp.traces{2}(3) & nS > 0;
    allInOne = ~~xp.traces{2}(4);
    savePrm = xp.traces{2}(5);
    saveGam = xp.traces{2}(6);  % added by FS, 19.3.2018
    if savePrm == 1 % external file
        pname_xp = setCorrectPath([pname 'parameters'], h_fig);
    end
end

%% Histograms
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

%% Dwell-times
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

%% Figures
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
            n = n + 1;
            str = ['export data of molecule n:°' num2str(m) '(' ...
                num2str(n) ' on ' num2str(N) '):'];

            if fromTT && xp.process
                p = updateTraces(h_fig, 'ttPr', m, p, []);
                intensities = p.proj{proj}.intensities_denoise;
                intensities_DTA = p.proj{proj}.intensities_DTA;
                
                % we export always in counts (confusion when
                % re-importing ASCII to MASH for merging data)
%                 if perSec
%                     intensities = intensities/rate;
%                     intensities_DTA = intensities_DTA/rate;
%                 end
%                 if perPix
%                     intensities = intensities/nPix;
%                     intensities_DTA = intensities_DTA/nPix;
%                 end

                FRET_DTA = p.proj{proj}.FRET_DTA;
                S_DTA = p.proj{proj}.S_DTA;
            end

            incl = p.proj{proj}.bool_intensities(:,m);
            [frames,o,o] = find(incl);
            frames = ((nExc*(frames(1)-1)+1):nExc*frames(end))';
            times = frames*rate;
            name_mol = [name '_mol' num2str(n) 'of' num2str(N)];
            if fromTT
                discrInt = ~p.proj{proj}.prm{m}{4}{1}(2) || ...
                    p.proj{proj}.prm{m}{4}{1}(2)==2;
            else
                discrInt = 1;
            end

            if fromTT && saveTr && savePrm < 3
                str_xp = getStrPrm(p.proj{proj}, m, h_fig);
            end

            %% traces

            if saveTr
                if saveAscii
                    if saveTr_I
                        head = '';
                        dat = [];
                        for l = 1:nExc
                            str_l = strcat(' at ', num2str(exc(l)), 'nm');
                            if l > 1
                                head = strcat(head, '\t');
                            end
                            dat = [dat times(l:nExc:end,:) ...
                                frames(l:nExc:end,:)];
                            head = strcat(head, 'time', str_l, ...
                                '\tframe', str_l);

                            for c = 1:nChan
                                dat = [dat ...
                                    intensities(incl,(m-1)*nChan+c,l)];
                                head = strcat(head, '\tI_', num2str(c), ...
                                    str_l,'(counts)');
                                if discrInt
                                    dat = [dat intensities_DTA(incl, ...
                                        (m-1)*nChan+c,l)];
                                    head = strcat(head, '\tdiscr.I_', ...
                                        num2str(c), str_l,'(counts)');
                                end
                            end
                        end
                        head_I = head;
                        fmt_I = repmat('%d\t', [1,...
                            ((discrInt+1)*nExc*nChan+2*nExc)]);
                        dat_I = dat;
                        if ~allInOne
                            fname_ascii = [name_mol '_I.txt'];
                            new_fname_ascii = overwriteIt(fname_ascii, ...
                                pname_ascii, h_fig);
                            if isempty(new_fname_ascii)
                                return;
                            end
                            if ~isequal(new_fname_ascii,fname_ascii)
                                fname_ascii = new_fname_ascii;
                                [o,name_mol,o] = ...
                                    fileparts(new_fname_ascii);
                                curs = strfind(name_mol, '_mol');
                                if ~isempty(curs)
                                    name = name_mol(1:(curs-1));
                                else
                                   curs = strfind(name_mol, 'mol'); 
                                   if ~isempty(curs)
                                       name = name_mol(1:(curs-1));
                                   else
                                       name = name_mol;
                                   end
                                   name_mol = [name '_mol' num2str(n) ...
                                       'of' num2str(N)];
                                   fname_ascii = [name_mol '_I.txt'];
                                end
                                name = name_mol(1:(curs-1));
                            end
                            f = fopen([pname_ascii fname_ascii], 'Wt');
                            if fromTT && savePrm == 2
                                fprintf(f, [str_xp '\n']);
                            end
                            fprintf(f, strcat(head_I, '\n'));
                            fprintf(f, [fmt_I '\n'], dat');
                            fclose(f);
                            str = [str ...
                                '\nIntensity traces saved to ASCII ' ...
                                'file: ' fname_ascii '\n in folder: ' ...
                                pname_ascii];
                        end
                    else
                        head_I = [];
                        fmt_I = [];
                        dat_I = [];
                    end
                    if saveTr_fret
                        head = [];
                        dat = [];
                        if fromTT
                            gamma = p.proj{proj}.prm{m}{5}{3};
                        else
                            gamma = 1;
                        end
                        FRET_all = calcFRET(nChan, nExc, exc, chanExc, ...
                            FRET, intensities(incl, ...
                            (((m-1)*nChan+1):m*nChan),:), gamma);
                        for c = 1:nChan
                            [i,o,o] = find(FRET(:,1)== c);
                            if ~isempty(i)
                                str_l = [' at ' num2str(chanExc(c)) 'nm'];
                                if ~isempty(head)
                                    head = [head '\t'];
                                end
                                [o,l,o] = find(exc==chanExc(c));
                                dat = [dat times(l:nExc:end,:) ...
                                    frames(l:nExc:end,:)];
                                head = [head 'time' str_l '\tframe' str_l];

                                for j = i'
                                    dat = [dat FRET_all(:,j)];
                                    dat = [dat FRET_DTA(incl, ...
                                            (m-1)*nFRET+j)];
                                    head = [head '\tFRET_' ...
                                        num2str(FRET(j,1)) '>' ...
                                        num2str(FRET(j,2)) ...
                                        '\tdiscr.FRET_' ...
                                        num2str(FRET(j,1)) '>' ...
                                        num2str(FRET(j,2))];
                                end
                            end
                        end
                        head_fret = head;
                        fmt_fret = repmat('%d\t', ...
                            [1,(2*nFRET+2*numel(unique(FRET(:,1))))]);
                        dat_fret = dat;

                        if ~allInOne
                            fname_ascii = [name_mol '_FRET.txt'];
                            new_fname_ascii = overwriteIt(fname_ascii, ...
                                pname_ascii, h_fig);
                            if isempty(new_fname_ascii)
                                return;
                            end
                            if ~isequal(new_fname_ascii,fname_ascii)
                                fname_ascii = new_fname_ascii;
                                [o,name_mol,o] = ...
                                    fileparts(new_fname_ascii);
                                curs = strfind(name_mol, '_mol');
                                if ~isempty(curs)
                                    name = name_mol(1:(curs-1));
                                else
                                   curs = strfind(name_mol, 'mol'); 
                                   if ~isempty(curs)
                                       name = name_mol(1:(curs-1));
                                   else
                                       name = name_mol;
                                   end
                                   name_mol = [name '_mol' num2str(n) ...
                                       'of' num2str(N)];
                                   fname_ascii = [name_mol '_FRET.txt'];
                                end
                                name = name_mol(1:(curs-1));
                            end
                            f = fopen([pname_ascii fname_ascii], 'Wt');
                            if fromTT && savePrm == 2
                                fprintf(f, [str_xp '\n']);
                            end
                            fprintf(f, strcat(head_fret, '\n'));
                            fprintf(f, [fmt_fret '\n'], dat_fret');
                            fclose(f);
                            str = [str ...
                                '\nFRET traces saved to ASCII file: '...
                                fname_ascii '\n in folder: ' pname_ascii];
                        end
                    else
                        head_fret = [];
                        fmt_fret = [];
                        dat_fret = [];
                    end
                    if saveTr_S
                        head = [];
                        dat = [];
                        for s = 1:nS
                            str_l = [' at ' num2str(chanExc(S(s))) 'nm'];
                            [o,l,o] = find(chanExc(S(s))==exc);
                            if ~isempty(head)
                                head = [head '\t'];
                            end
                            dat = [dat times(l:nExc:end,:) ...
                                frames(l:nExc:end,:)];
                            head = [head 'time' str_l '\tframe' str_l];

                            Inum = sum(intensities(incl, ...
                                ((m-1)*nChan+1):m*nChan,l),2);
                            Iden = sum(sum(intensities(incl, ...
                                ((m-1)*nChan+1):m*nChan,:),2),3);
                            dat = [dat Inum./Iden];
                            dat = [dat S_DTA(incl,(m-1)*nS+s)];

                            head = [head '\tS_' labels{S(s)} ...
                                '\tdiscr.S_' labels{S(s)}];
                        end
                        head_s = head;
                        fmt_s = repmat('%d\t', [1,4*nS]);
                        dat_s = dat;
                        if ~allInOne
                            fname_ascii = [name_mol '_S.txt'];
                            new_fname_ascii = overwriteIt(fname_ascii, ...
                                pname_ascii, h_fig);
                            if isempty(new_fname_ascii)
                                return;
                            end
                            if ~isequal(new_fname_ascii,fname_ascii)
                                fname_ascii = new_fname_ascii;
                                [o,name_mol,o] = ...
                                    fileparts(new_fname_ascii);
                                curs = strfind(name_mol, '_mol');
                                if ~isempty(curs)
                                    name = name_mol(1:(curs-1));
                                else
                                   curs = strfind(name_mol, 'mol'); 
                                   if ~isempty(curs)
                                       name = name_mol(1:(curs-1));
                                   else
                                       name = name_mol;
                                   end
                                   name_mol = [name '_mol' num2str(n) ...
                                       'of' num2str(N)];
                                   fname_ascii = [name_mol '_S.txt'];
                                end
                                name = name_mol(1:(curs-1));
                            end
                            f = fopen([pname_ascii fname_ascii], 'Wt');
                            if fromTT && savePrm == 2
                                fprintf(f, [str_xp '\n']);
                            end
                            fprintf(f, strcat(head_s, '\n'));
                            fprintf(f, [fmt_s '\n'], dat');
                            fclose(f);
                            str = [str ...
                                '\nS traces saved to ASCII file: ' ...
                                fname_ascii '\n in folder: ' pname_ascii];
                        end
                    else
                        head_s = [];
                        fmt_s = [];
                        dat_s = [];
                    end
                    if allInOne
                        fname_ascii = [name_mol '.txt'];
                        new_fname_ascii = overwriteIt(fname_ascii, ...
                            pname_ascii, h_fig);
                        if isempty(new_fname_ascii)
                            return;
                        end
                        if ~isequal(new_fname_ascii,fname_ascii)
                            fname_ascii = new_fname_ascii;
                            [o,name_mol,o] = fileparts(new_fname_ascii);
                            curs = strfind(name_mol, '_mol');
                            if ~isempty(curs)
                                name = name_mol(1:(curs-1));
                            else
                               curs = strfind(name_mol, 'mol'); 
                               if ~isempty(curs)
                                   name = name_mol(1:(curs-1));
                               else
                                   name = name_mol;
                               end
                               name_mol = [name '_mol' num2str(n) 'of' ...
                                   num2str(N)];
                               fname_ascii = [name_mol '.txt'];
                            end
                        end
                        f = fopen([pname_ascii fname_ascii], 'Wt');
                        if fromTT && savePrm == 2
                            fprintf(f, [str_xp '\n']);
                        end
                        fprintf(f, [head_I '\t' head_fret '\t' head_s ...
                            '\n']);
                        fprintf(f, [fmt_I fmt_fret fmt_s '\n'], ...
                            [dat_I dat_fret dat_s]');
                        fclose(f);
                        str = [str '\nTraces saved to ASCII file: ' ...
                            fname_ascii '\n in folder: ' pname_ascii];
                    end
                end

                for j = 1:nFRET
                    ext_f = ['FRET' num2str(FRET(j,1)) 'to' ...
                        num2str(FRET(j,2))];
                    [o,l,o] = find(exc==chanExc(FRET(j,1)));
                    I_fret{j}{n} = ...
                        intensities(incl,[(m-1)*nChan+FRET(j,1) ...
                        (m-1)*nChan+FRET(j,2)],l);
                    
%                     % clip outliers
%                     FRETtrajs = I_fret{j}{n}(:,2)./ sum(I_fret{j}{n},2);
%                     incldat = FRETtrajs >= -0.2 & FRETtrajs <= 1.2;
                    incldat = true(size(I_fret{j}{n}(:,1)));

                    if saveHa
                        fname_ha = [name_mol ext_f '_HaMMy.dat'];
                        new_fname_ha = overwriteIt(fname_ha, pname_ha, ...
                            h_fig);
                        if isempty(new_fname_ha)
                            return;
                        end
                        if ~isequal(new_fname_ha,fname_ha)
                            fname_ha = new_fname_ha;
                            [o,name_mol,o] = fileparts(new_fname_ha);
                            curs = strfind(name_mol, '_mol');
                            if ~isempty(curs)
                                name = name_mol(1:(curs-1));
                            else
                               curs = strfind(name_mol, 'mol'); 
                               if ~isempty(curs)
                                   name = name_mol(1:(curs-1));
                               else
                                   name = name_mol;
                               end
                               name_mol = [name '_mol' num2str(n) 'of' ...
                                   num2str(N)];
                               fname_ha = [name_mol ext_f '_HaMMy.dat'];
                            end
                        end
                        f = fopen([pname_ha fname_ha], 'Wt');
                        timeAxis = times(l:nExc:end,1);
                        fprintf(f, '%d\t%d\t%d\n', ...
                            [timeAxis(incldat,1),I_fret{j}{n}(incldat,:)]');
                        fclose(f);

                        str = [str '\nTraces (' ext_f ') saved to ' ...
                            'HaMMy-compatible file: ' fname_ha '\n in ' ...
                            'folder: ' pname_ha];
                    end

                    if saveSmart
                        tr_fret = I_fret{j}{n};
                        fname_smart = [name '_all' num2str(N) ext_f ...
                            '_SMART.traces'];
                        new_fname_smart = overwriteIt(fname_smart, ...
                            pname_smart, h_fig);
                        if isempty(new_fname_smart)
                            return;
                        end
                        if ~isequal(new_fname_smart,fname_smart)
                            fname_smart = new_fname_smart;
                            [o,name_all,o] = fileparts(new_fname_smart);
                            curs = strfind(name_all, '_all');
                            if ~isempty(curs)
                                name = name_all(1:(curs-1));
                            else
                               curs = strfind(name_all, 'all'); 
                               if ~isempty(curs)
                                   name = name_all(1:(curs-1));
                               else
                                   name = name_all;
                               end
                               fname_smart = [name '_all' num2str(N) ...
                                   ext_f '_SMART.traces'];
                            end
                        end
                        data_smart{j}{n,1}.name = fname_smart;
                        data_smart{j}{n,1}.gp_num = NaN;
                        data_smart{j}{n,1}.movie_num = 1;
                        data_smart{j}{n,1}.movie_ser = 1;
                        data_smart{j}{n,1}.trace_num = n;
                        data_smart{j}{n,1}.spots_in_movie = N;
                        data_smart{j}{n,1}.position_x = coord(m, ...
                            (2*FRET(j,1)-1));
                        data_smart{j}{n,1}.position_y = ...
                            coord(m,2*FRET(j,1));
                        data_smart{j}{n,1}.positions = coord(mol_incl, ...
                            (2*FRET(j,1)-1):2*FRET(j,1));
                        data_smart{j}{n,1}.fps = rate*nExc;
                        data_smart{j}{n,1}.len = size(tr_fret,1);
                        data_smart{j}{n,1}.nchannels = 2;
                        data_smart{j}{n,2} = tr_fret;
                        data_smart{j}{n,3} = true(size(tr_fret,1),1);
                    end

                    if saveEbfret
                        data_ebfret{j} = [data_ebfret{j}; ...
                            [ones(size(I_fret{j}{n},1),1)*n I_fret{j}{n}]];
                        fname_ebfret = [name '_all' num2str(N) ext_f ...
                            '_ebFRET.dat'];
                        new_fname_ebfret = overwriteIt(fname_ebfret, ...
                            pname_ebfret, h_fig);
                        if isempty(new_fname_ebfret)
                            return;
                        end
                        if ~isequal(new_fname_ebfret,fname_ebfret)
                            fname_ebfret = new_fname_ebfret;
                            [o,name_all,o] = fileparts(new_fname_ebfret);
                            curs = strfind(name_all, '_all');
                            if ~isempty(curs)
                                name = name_all(1:(curs-1));
                            else
                               curs = strfind(name_all, 'all'); 
                               if ~isempty(curs)
                                   name = name_all(1:(curs-1));
                               else
                                   name = name_all;
                               end
                               fname_ebfret = [name '_all' num2str(N) ext_f ...
                                   '_ebFRET.dat'];
                            end
                        end
                    end
                    if saveQub
                        data = I_fret{j}{n};
                        fname_qub = [name_mol ext_f '_QUB.txt'];
                        new_fname_qub = overwriteIt(fname_qub, ...
                            pname_qub, h_fig);
                        if isempty(new_fname_qub)
                            return;
                        end
                        if ~isequal(new_fname_qub,fname_qub)
                            fname_qub = new_fname_qub;
                            [o,name_mol,o] = fileparts(new_fname_qub);
                            curs = strfind(name_mol, '_mol');
                            if ~isempty(curs)
                                name = name_mol(1:(curs-1));
                            else
                               curs = strfind(name_mol, 'mol'); 
                               if ~isempty(curs)
                                   name = name_mol(1:(curs-1));
                               else
                                   name = name_mol;
                               end
                               name_mol = [name '_mol' num2str(n) 'of' ...
                                   num2str(N)];
                               fname_qub = [name_mol ext_f '_QUB.txt'];
                            end
                        end
                        save([pname_qub fname_qub], 'data', '-ascii');
                        str = [str '\nTraces (' ext_f ') saved to ' ...
                            'QUB-compatible file: ' fname_qub '\n in ' ...
                            'folder: ' pname_qub];
                    end
                end
                if fromTT && savePrm == 1 % external param file
                    fname_xp = [name_mol '.log'];
                    new_fname_xp = overwriteIt(fname_xp, pname_xp, ...
                        h_fig);
                    if isempty(new_fname_xp)
                        return;
                    end
                    if ~isequal(new_fname_xp,fname_xp)
                        fname_xp = new_fname_xp;
                        [o,name_mol,o] = fileparts(new_fname_xp);
                        curs = strfind(name_mol, '_mol');
                        if ~isempty(curs)
                            name = name_mol(1:(curs-1));
                        else
                           curs = strfind(name_mol, 'mol'); 
                           if ~isempty(curs)
                               name = name_mol(1:(curs-1));
                           else
                               name = name_mol;
                           end
                           name_mol = [name '_mol' num2str(n) 'of' ...
                               num2str(N)];
                           fname_xp = [name_mol '.log'];
                        end
                    end
                    f = fopen([pname_xp fname_xp], 'Wt');
                    fprintf(f, str_xp);
                    fclose(f);
                    str = [str '\nParameters saved to file: ' fname_xp ...
                        '\n in folder: ' pname_xp];
                end
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
                            I = intensities(incl,(m-1)*nChan+c,l);
                            histI = [];
                            histI(:,1) = x_I';
                            histI(:,2) = (hist(I,x_I))';
                            histI(:,3) = histI(:,2)/sum(histI(:,2));
                            histI(:,4) = cumsum(histI(:,2));
                            histI(:,5) = histI(:,4)/histI(end,4);
                            fname_histI = [name_mol '_I' num2str(c) '-' ...
                                num2str(exc(l)) '.h2'];
                            new_fname_histI = overwriteIt(fname_histI, ...
                                pname_hist, h_fig);
                            if isempty(new_fname_histI)
                                return;
                            end
                            if ~isequal(new_fname_histI,fname_histI)
                                fname_histI = new_fname_histI;
                                [o,name_mol,o] = ...
                                    fileparts(new_fname_histI);
                                curs = strfind(name_mol, '_mol');
                                if ~isempty(curs)
                                    name = name_mol(1:(curs-1));
                                else
                                   curs = strfind(name_mol, 'mol'); 
                                   if ~isempty(curs)
                                       name = name_mol(1:(curs-1));
                                   else
                                       name = name_mol;
                                   end
                                   name_mol = [name '_mol' num2str(n) ...
                                       'of' num2str(N)];
                                   fname_histI = [name_mol '_I' ...
                                       num2str(c) '-' num2str(exc(l)) ...
                                       '.h2'];
                                end
                            end
                            save([pname_hist fname_histI], 'histI', ...
                                '-ascii');
                            str = [str '\nIntensity(channel ' ...
                                num2str(c) ', ' num2str(exc(l)) ...
                                'nm) histograms saved to ASCII file: ' ...
                                fname_histI '\n in ' 'folder: ' ...
                                pname_hist];
                            if inclDiscr && discrInt
                                [o,fname_hist_dI,o] = ...
                                    fileparts(fname_histI);
                                fname_hist_dI = [fname_hist_dI '.hd2'];
                                discrI = ...
                                    intensities_DTA(incl,(m-1)*nChan+c,l);
                                hist_dI = [];
                                hist_dI(:,1) = x_I';
                                hist_dI(:,2) = (hist(discrI,x_I))';
                                hist_dI(:,3) = ...
                                    hist_dI(:,2)/sum(hist_dI(:,2));
                                hist_dI(:,4) = cumsum(hist_dI(:,2));
                                hist_dI(:,5) = hist_dI(:,4)/hist_dI(end,4);
                                save([pname_hist fname_hist_dI], ...
                                    'hist_dI', '-ascii');
                                str = [str '\nDiscretised intensity' ...
                                    '(channel ' num2str(c) ', ' ...
                                    num2str(exc(l)) 'nm) histograms ' ...
                                    'saved to ASCII file: ' ...
                                    fname_hist_dI '\n in folder: ' ...
                                    pname_hist];
                            end
                        end
                    end
                end
                if saveHst_fret
                    x_fret = minFret:binFret:maxFret;
                    if fromTT
                        gamma = p.proj{proj}.prm{m}{5}{3};
                    else
                        gamma = 1;
                    end
                    FRET_all = calcFRET(nChan, nExc, exc, chanExc,FRET, ...
                        intensities(incl,(((m-1)*nChan+1):m*nChan),:), gamma);
                    for i = 1:nFRET
                        FRET_tr = FRET_all(:,i);
                        histF = [];
                        histF(:,1) = x_fret';
                        histF(:,2) = (hist(FRET_tr,x_fret))';
                        histF(:,3) = histF(:,2)/sum(histF(:,2));
                        histF(:,4) = cumsum(histF(:,2));
                        histF(:,5) = histF(:,4)/histF(end,4);
                        fname_histF = [name_mol '_FRET' ...
                            num2str(FRET(i,1)) 'to' num2str(FRET(i,2)) ...
                            '.h2'];
                        new_fname_histF = overwriteIt(fname_histF, ...
                            pname_hist, h_fig);
                        if isempty(new_fname_histF)
                            return;
                        end
                        if ~isequal(new_fname_histF,fname_histF)
                            fname_histF = new_fname_histF;
                            [o,name_mol,o] = fileparts(new_fname_histF);
                            curs = strfind(name_mol, '_mol');
                            if ~isempty(curs)
                                name = name_mol(1:(curs-1));
                            else
                               curs = strfind(name_mol, 'mol'); 
                               if ~isempty(curs)
                                   name = name_mol(1:(curs-1));
                               else
                                   name = name_mol;
                               end
                               name_mol = [name '_mol' num2str(n) ...
                                   'of' num2str(N)];
                               fname_histF = [name_mol '_FRET' num2str( ...
                                   FRET(i,1)) 'to' num2str(FRET(i,2)) ...
                                   '.h2'];
                            end
                        end
                        save([pname_hist fname_histF], 'histF', '-ascii');
                        str = [str '\nFRET (' num2str(FRET(i,1)) ' to ' ...
                            num2str(FRET(i,2)) ') histograms saved to' ...
                            'ASCII file: ' fname_histF '\n in folder: ' ...
                            pname_hist];
                        if inclDiscr
                            [o,fname_hist_dF,o] = fileparts(fname_histF);
                            fname_hist_dF = [fname_hist_dF '.hd2'];
                            discrFRET = FRET_DTA(incl,(m-1)*nFRET+i);
                            hist_dF = [];
                            hist_dF(:,1) = x_fret';
                            hist_dF(:,2) = (hist(discrFRET,x_fret))';
                            hist_dF(:,3) = hist_dF(:,2)/sum(hist_dF(:,2));
                            hist_dF(:,4) = cumsum(hist_dF(:,2));
                            hist_dF(:,5) = hist_dF(:,4)/hist_dF(end,4);
                            save([pname_hist fname_hist_dF], 'hist_dF', ...
                                '-ascii');
                            str = [str '\nDiscretised FRET (' ...
                                num2str(FRET(i,1)) ' to ' ...
                                num2str(FRET(i,2)) ') histograms saved' ...
                                'to ASCII file: ' fname_hist_dF ...
                                '\nin folder: ' pname_hist];
                        end
                    end
                end
                if saveHst_S
                    x_s = minS:binS:maxS;
                    for i = 1:nS
                        [o,l_s,o] = find(exc==chanExc(S(i)));
                        Inum = sum(intensities(incl,((m-1)*nChan+1): ...
                            m*nChan,l_s),2);
                        Iden = sum(sum(intensities(incl,((m-1)*nChan+1): ...
                            m*nChan,:),2),3);
                        S_tr = Inum./Iden;
                        histS = [];
                        histS(:,1) = x_s';
                        histS(:,2) = (hist(S_tr,x_s))';
                        histS(:,3) = histS(:,2)/sum(histS(:,2));
                        histS(:,4) = cumsum(histS(:,2));
                        histS(:,5) = histS(:,4)/histS(end,4);
                        fname_histS = [name_mol '_S' labels{S(i)} '.h2'];
                        new_fname_histS = overwriteIt(fname_histS, ...
                            pname_hist, h_fig);
                        if isempty(new_fname_histS)
                            return;
                        end
                        if ~isequal(new_fname_histS,fname_histS)
                            fname_histS = new_fname_histS;
                            [o,name_mol,o] = fileparts(fname_histS);
                            curs = strfind(name_mol, '_mol');
                            if ~isempty(curs)
                                name = name_mol(1:(curs-1));
                            else
                               curs = strfind(name_mol, 'mol'); 
                               if ~isempty(curs)
                                   name = name_mol(1:(curs-1));
                               else
                                   name = name_mol;
                               end
                               name_mol = [name '_mol' num2str(n) ...
                                   'of' num2str(N)];
                               fname_histS = [name_mol '_S' labels{S(i)}...
                                   '.h2'];
                            end
                        end
                        save([pname_hist fname_histS], 'histS', '-ascii');
                        str = [str '\nStoichiometry (' labels{S(i)} ...
                            ') histograms saved to ASCII file: ' ...
                            fname_histS '\n in folder: ' pname_hist];

                        if inclDiscr
                            [o,fname_hist_dS,o] = fileparts(fname_histS);
                            fname_hist_dS = [fname_hist_dS '.hd2'];
                            discrS = S_DTA(incl,(m-1)*nS+i);
                            hist_dS = [];
                            hist_dS(:,1) = x_s';
                            hist_dS(:,2) = (hist(discrS,x_s))';
                            hist_dS(:,3) = hist_dS(:,2)/sum(hist_dS(:,2));
                            hist_dS(:,4) = cumsum(hist_dS(:,2));
                            hist_dS(:,5) = hist_dS(:,4)/hist_dS(end,4);
                            save([pname_hist fname_hist_dS], 'hist_dS', ...
                                '-ascii');
                            str = [str '\nDiscretised Stoichiometry (' ...
                                labels{S(i)} ') histograms saved to ' ...
                                'ASCII file: ' fname_hist_dS '\n in ' ...
                                'folder: ' pname_hist];
                        end
                    end
                end
            end

            %% Dwell-times

            if saveDt
                if (saveDt_I  || saveKin) && discrInt
                    for l = 1:nExc
                        for c = 1:nChan
                            discr_I = ...
                                intensities_DTA(incl,(m-1)*nChan+c,l);
                            dt_I = getDtFromDiscr(discr_I, rate);
                            
                            
                            fname_dtI = [name_mol '_I' num2str(c) '-' ...
                                num2str(exc(l)) '.dt'];
                            new_fname_dtI = overwriteIt(fname_dtI, ...
                                pname_dt, h_fig);
                            if isempty(new_fname_dtI)
                                return;
                            end
                            if ~isequal(new_fname_dtI,fname_dtI)
                                fname_dtI = new_fname_dtI;
                                [o,name_mol,o] = fileparts(fname_dtI);
                                curs = strfind(name_mol, '_mol');
                                if ~isempty(curs)
                                    name = name_mol(1:(curs-1));
                                else
                                   curs = strfind(name_mol, 'mol'); 
                                   if ~isempty(curs)
                                       name = name_mol(1:(curs-1));
                                   else
                                       name = name_mol;
                                   end
                                   name_mol = [name '_mol' num2str(n) ...
                                       'of' num2str(N)];
                                   fname_dtI = [name_mol '_I' ...
                                       num2str(c) '-' num2str(exc(l)) ...
                                       '.dt'];
                                end
                            end
                            if saveDt_I 
                                save([pname_dt fname_dtI], 'dt_I', ...
                                    '-ascii');
                            end
                            if saveKin && size(dt_I,1) > 1 && ...
                                    numel(unique(dt_I(:,2:3))) <= 6
                                kinDat = getKinDat(dt_I);
                                upgradeKinFile([pname_dt fname_kinI], ...
                                    fname_dtI, kinDat);
                            end
                        end
                    end
                end
                if saveDt_fret || saveKin
                    for i = 1:nFRET
                        discr_F = FRET_DTA(incl,(m-1)*nFRET+i);
                        dt_F = getDtFromDiscr(discr_F, rate);

                        fname_dtF = [name_mol '_FRET' num2str(FRET(i,1))...
                            'to' num2str(FRET(i,2)) '.dt'];
                        new_fname_dtF = overwriteIt(fname_dtF, ...
                            pname_dt, h_fig);
                        if isempty(new_fname_dtF)
                            return;
                        end
                        if ~isequal(new_fname_dtF,fname_dtF)
                            fname_dtF = new_fname_dtF;
                            [o,name_mol,o] = fileparts(fname_dtF);
                            curs = strfind(name_mol, '_mol');
                            if ~isempty(curs)
                                name = name_mol(1:(curs-1));
                            else
                               curs = strfind(name_mol, 'mol'); 
                               if ~isempty(curs)
                                   name = name_mol(1:(curs-1));
                               else
                                   name = name_mol;
                               end
                               name_mol = [name '_mol' num2str(n) 'of' ...
                                   num2str(N)];
                               fname_dtF = [name_mol '_FRET' num2str( ...
                                   FRET(i,1)) 'to' num2str(FRET(i,2)) ...
                                   '.dt'];
                            end
                        end
                        if saveDt_fret
                            save([pname_dt fname_dtF], 'dt_F', '-ascii');
                        end

                        if saveKin && size(dt_F,1) > 1 && ...
                                numel(unique(dt_F(:,2:3))) <= 6
                            kinDat = getKinDat(dt_F);
                            upgradeKinFile([pname_dt fname_kinF], ...
                                fname_dtF, kinDat)
                        end
                    end
                end
                if saveDt_S || saveKin
                    for i = 1:nS
                        discr_S = S_DTA(incl,(m-1)*nS+i);
                        dt_S = getDtFromDiscr(discr_S, rate);

                        fname_dtS = [name_mol '_S' labels{S(i)} '.dt'];
                        new_fname_dtS = overwriteIt(fname_dtS, ...
                            pname_dt, h_fig);
                        if isempty(new_fname_dtS)
                            return;
                        end
                        if ~isequal(new_fname_dtS,fname_dtS)
                            fname_dtS = new_fname_dtS;
                            [o,name_mol,o] = fileparts(fname_dtS);
                            curs = strfind(name_mol, '_mol');
                            if ~isempty(curs)
                                name = name_mol(1:(curs-1));
                            else
                               curs = strfind(name_mol, 'mol'); 
                               if ~isempty(curs)
                                   name = name_mol(1:(curs-1));
                               else
                                   name = name_mol;
                               end
                               name_mol = [name '_mol' num2str(n) ...
                                   'of' num2str(N)];
                               fname_dtS = [name_mol '_S' labels{S(i)} ...
                                   '.dt'];
                            end
                        end
                        if saveDt_S
                            save([pname_dt fname_dtS], 'dt_S', '-ascii');
                        end
                        if saveKin && size(dt_S,1) > 1 && ...
                                numel(unique(dt_S(:,2:3))) <= 6
                            kinDat = getKinDat(dt_S);
                            upgradeKinFile([pname_dt fname_kinS], ...
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
%                             fname_fig = [name '_all' num2str(N) '.ps'];
%                             print(h_fig_mol, [pname_fig fname_fig], ...
%                                 '-dpsc', '-append');
                            fname_fig{nfig} = cat(2,pname_fig_temp, ...
                                filesep,name,'_mol',num2str(n_prev),'-', ...
                                num2str(n),'of',num2str(N),'.pdf');
                            print(h_fig_mol,fname_fig{nfig},'-dpdf');
%                             [o,m_prev,o] = find(m_ind == n_prev);
%                             [o,m_stop,o] = find(m_ind == n);
%                             str = [str '\nFigures of molecule n:°' ...
%                                 num2str(m_prev(1)) ' to ' ...
%                                 num2str(m_stop(1)) ...
%                                 ' saved to *.pdf file: ' fname_fig{nfig} ...
%                                 '\n in folder: ' pname_fig];
                            nfig = nfig + 1;

                        case 2 % png
                            fname_fig = [name '_mol' num2str(n_prev) ...
                                '-' num2str(n) 'of' num2str(N) '.png'];
                            print(h_fig_mol, [pname_fig fname_fig], ...
                                '-dpng');
%                             [o,m_prev,o] = find(m_ind == n_prev);
%                             [o,m_stop,o] = find(m_ind == n);
%                             str = [str '\nFigures of molecule n:°' ...
%                                 num2str(m_prev(1)) ' to ' ...
%                                 num2str(m_stop(1)) ...
%                                 ' saved to *.png file: ' fname_fig ...
%                                 '\n in folder: ' pname_fig];

                        case 3 % jpg
                            fname_fig = [name '_mol' num2str(n_prev) '-'...
                                num2str(n) 'of' num2str(N) '.jpeg'];
                            print(h_fig_mol, [pname_fig fname_fig], ...
                                '-djpeg');
%                             [o,m_prev,o] = find(m_ind == n_prev);
%                             [o,m_stop,o] = find(m_ind == n);
%                             str = [str '\nFigures of molecule n:°' ...
%                                 num2str(m_prev(1)) ' to ' ...
%                                 num2str(m_stop(1)) ...
%                                 ' saved to *.jpg file: ' fname_fig ...
%                                 '\n in folder: ' pname_fig];
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
        ext_f = ['FRET' num2str(FRET(j,1)) 'to' num2str(FRET(j,2))];
        if saveSmart
            fname_smart = [name '_all' num2str(N) ext_f ...
                '_SMART.traces'];
            new_fname_smart = overwriteIt(fname_smart, pname_smart, ...
                    h_fig);
            if isempty(new_fname_smart)
                return;
            end
            if ~isequal(new_fname_smart,fname_smart)
                fname_smart = new_fname_smart;
                [o,name_all,o] = fileparts(new_fname_smart);
                curs = strfind(name_all, '_all');
                if ~isempty(curs)
                    name = name_all(1:(curs-1));
                else
                   curs = strfind(name_all, 'all'); 
                   if ~isempty(curs)
                       name = name_all(1:(curs-1));
                   else
                       name = name_all;
                       name_all = [name '_mol' num2str(n) ...
                           'of' num2str(N)];
                       fname_smart = [name_all ext_f '_SMART.txt'];
                   end
                end
            end
            group_data = data_smart{j};
            save([pname_smart fname_smart], 'group_data', '-mat');
            updateActPan(['Traces (' ext_f ') saved to ' ...
                'SMART-compatible file: ' fname_smart '\n in ' ...
                'folder: ' pname_smart], h_fig, 'process');
        end
        if saveVbfret
            fname_vbfret = [name '_all' num2str(N) ext_f ...
                '_VbFRET.mat'];
            data = I_fret{j};
            save([pname_vbfret fname_vbfret], 'data', '-mat');
            updateActPan(['Traces (' ext_f ') saved to ' ...
                'VbFRET-compatible file: ' fname_vbfret '\n in ' ...
                'folder: ' pname_vbfret], h_fig, 'process');
        end
        if saveEbfret
            fname_ebfret = [name '_all' num2str(N) ext_f ...
                '_ebFRET.dat'];
            new_fname_ebfret = overwriteIt(fname_ebfret, pname_ebfret, ...
                    h_fig);
            if isempty(new_fname_ebfret)
                return;
            end
            if ~isequal(new_fname_ebfret,fname_ebfret)
                fname_ebfret = new_fname_ebfret;
                [o,name_all,o] = fileparts(new_fname_ebfret);
                curs = strfind(name_all, '_all');
                if ~isempty(curs)
                    name = name_all(1:(curs-1));
                else
                   curs = strfind(name_all, 'all'); 
                   if ~isempty(curs)
                       name = name_all(1:(curs-1));
                   else
                       name = name_all;
                       name_all = [name '_mol' num2str(n) ...
                           'of' num2str(N)];
                       fname_ebfret = [name_all ext_f '_ebFRET.txt'];
                   end
                end
            end
            f = fopen([pname_ebfret fname_ebfret], 'Wt');
            fprintf(f, '%d\t%d\t%d\n', data_ebfret{j}');
            fclose(f);
            updateActPan(['Traces (' ext_f ') saved to ' ...
                'ebFRET-compatible file: ' fname_ebfret '\n in ' ...
                'folder: ' pname_ebfret], h_fig, 'process');
        end
    end
end

%% Figure complement
if saveFig && figFmt == 1 % *.pdf
%     try
%         ps2pdf('psfile', [pname_fig fname_fig], 'pdffile', [pname_fig ...
%             fname_pdf]);
%         delete([pname_fig fname_fig]);
%         updateActPan(['Figures saved to PDF file: ' fname_pdf '\n in ' ...
%             'folder: ' pname_fig], h_fig, 'process');
%     catch err
%         updateActPan(['Impossible to save figures to PDF file.\n\n' ...
%             'MATLAB error: ' err.message '\n\n' ...
%             'Advice: change in the option menu (>Edit) the export ' ...
%             'format to *.png or *.jpg'], h_fig, 'error');
%     end
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






