function s = intAscii2mash(pname, fname, s, p, h_fig)

% Last update, 8.4.2019 by MH: fix errors occurring when improting discretized FRET traces
% update, 3.4.2019 by MH: (1) correct boolean data according to each molecule's NaN (2) correct discretized FRET import for more than one laser excitation: import FRET data at donor excitation, fill missing discretized FRET data with NaNs instead of falses and manage import failure. (2) change "frame_rate" name to "exptime"
% update 28.3.2019 by MH: (1) Display all function and code line when an error occurs (2) Fix error when importing coordinates from file (3) Manage error when importing a number of coordinates from file different from number of intensity-time traces

% defaults
coordintrace = false;

% collect project parameters
exptime = s.frame_rate;
nChan = s.nb_channel;
nExc = s.nb_excitations;
cip = s.coord_imp_param;
coordfile = s.coord_file;
coord = s.coord;
FRET = s.FRET;

% add discr. FRET import options if none
if size(p{1}{1},2)==8
    p{1}{1}(9) = 0;
    p{1}{1}(10) = 5;
    p{1}{1}(11) = 5;
    p{1}{1}(12) = 0;
end

delim = p{1}{1}(2);
rowwise = p{1}{1}(7);
isTime = p{1}{1}(3);
row1 = p{1}{1}(1)+1;
colI1 = p{1}{1}(5);
colI2 = p{1}{1}(6);
colI_exc = p{1}{3};
isdFRET = p{1}{1}(9);
colseq1 = p{1}{1}(10);
colseq2 = p{1}{1}(11);
colseqskip = p{1}{1}(12);
isGam = sum(p{6}{1}) & ~isempty(p{6}{2});
isBet = sum(p{6}{4}) & ~isempty(p{6}{5}) ;

if rowwise==2
    colI1 = colI_exc(:,1);
    colI2 = colI_exc(:,2);
end

nFRET = size(FRET,1);
if isGam
    gam_folder = p{6}{1};
    gam_files = p{6}{2};
    p{6}{3} = [];
    for f = 1:numel(gam_files)
        content = importdata(cat(2,gam_folder,gam_files{f}));
        if isstruct(content)
            pairs = getFRETfromFactorFiles(content.colheaders);
            if ~isequal(sortrows(pairs,[1,2]),sortrows(FRET,[1,2]))
                setContPan(['No gamma factor imported: FRET pairs in the ',...
                    'gamma factor file ',gam_files{f},' are inconsistent ',...
                    'with the pairs defined in the import options...'],...
                    '', h_fig);
                p{6}{1} = '';
                p{6}{2} = {};
                p{6}{3} = [];
                isGam = false;
                break
            end
            content = content.data;
        else
            pairs = FRET;
        end
        p{6}{3} = cat(1,p{6}{3},zeros(size(content,1),nFRET));
        for pair = 1:nFRET
            col = pairs(:,1)==FRET(pair,1) && pairs(:,2)==FRET(pair,2);
            p{6}{3}(end-size(content,1)+1:end,pair) = content(:,col);
        end
    end
end

if isBet
    bet_folder = p{6}{4};
    bet_files = p{6}{5};
    p{6}{6} = [];
    for f = 1:numel(bet_files)
        content = importdata(cat(2,bet_folder,bet_files{f}));
        if isstruct(content)
            pairs = getFRETfromFactorFiles(content.colheaders);
            if ~isequal(sortrows(pairs,[1,2]),sortrows(FRET,[1,2]))
                setContPan(['No beta factor imported: FRET pairs in the ',...
                    'beta factor file ',gam_files{f},' are inconsistent ',...
                    'with the pairs defined in the import options...'],...
                    '', h_fig);
                p{6}{4} = '';
                p{6}{5} = {};
                p{6}{6} = [];
                isBet = false;
                break
            end
            content = content.data;
        else
            pairs = FRET;
        end
        p{6}{6} = cat(1,p{6}{6},zeros(size(content,1),nFRET));
        for pair = 1:nFRET
            col = pairs(:,1)==FRET(pair,1) && pairs(:,2)==FRET(pair,2);
            p{6}{6}(end-size(content,1)+1:end,pair) = content(:,col);
        end
    end
end

intensities = [];
incl = [];
fret_DTA = [];
if isTime
    if rowwise==1
        colt = p{1}{1}(4);
    else
        colt = p{1}{2};
    end
else
    exptime = 1;
end

try
    if isTime
        times = [];
    end
    switch delim
        case 1
            delimchar = {sprintf('\t'),' '};
        case 2
            delimchar = sprintf('\t');
        case 3
            delimchar = ',';
        case 4
            delimchar = ';';
        case 5
            delimchar = ' ';
        otherwise
            delimchar = sprintf('\t');
    end
    for i = 1:size(fname,2)
        intNum = [];
        dfretNum = [];
        
        % read file
        fdat = {};
        f = fopen([pname fname{i}], 'r');
        while ~feof(f)
            rowdat = split(fgetl(f),delimchar)';
            excl = false(1,numel(rowdat));
            for col = 1:numel(rowdat)
                chars = unique(rowdat{col});
                if numel(chars)==0 || (numel(chars)==1 && chars==' ')
                    excl(col) = true;
                end
            end
            rowdat(excl) = [];
            if ~isempty(fdat) && size(rowdat,2)~=size(fdat,2)
                if size(rowdat,2)<size(fdat,2)
                    rowdat = cat(2,rowdat,...
                        cell(1,size(fdat,2)-size(rowdat,2)));
                else
                    fdat = cat(2,fdat,...
                        cell(size(fdat,1),size(rowdat,2)-size(fdat,2)));
                end
            end
            fdat = cat(1,fdat,rowdat);
        end
        fclose(f);
        
        % collect import parameters
        r_end = size(fdat,1);
        if colI2 == 0
            c_end = size(fdat,2);
        else
            c_end = colI2;
        end
        
        % format intensity and discretized data
        for r = row1:r_end
            dat = cellfun(@str2double,fdat(r,:));
            if ~isempty(dat)
                if isTime && i==1
                    times = cat(1,times,dat(1,colt));
                end
                if isdFRET
                    dfretNum_col = [];
                    for col = colseq1:(colseqskip+1):colseq2
                        dfretNum_col = cat(2,dfretNum_col,dat(1,col));
                    end
                    dfretNum = cat(1,dfretNum,dfretNum_col);
                end
                intNum_col = [];
                for lay = 1:numel(colI1)
                    for col = colI1(lay):c_end(lay)
                        intNum_col = cat(2,intNum_col,dat(1,col));
                    end
                end
                intNum = cat(1,intNum,intNum_col);
            end
        end
        
        if isempty(intNum)
            loading_bar('close', h_fig);
            updateActPan(['Unable to load intensity data from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            s = [];
            return
        end

        if isdFRET && isempty(dfretNum)
            updateActPan(['Unable to load discretized FRET from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            s = [];
            return
        end
        
        % get exposure time and laser order
        if isTime && i==1
            if rowwise
                exptime = abs(times(2)-times(1));
                lasord = 1:nExc;
            else
                [lasord,tfirstexc] = sort(times(1,:));
                exptime = abs(tfirstexc(2)-tfirstexc(1));
            end
        end
        
        % get data dimensions
        L_n = size(intNum,1);
        if rowwise==1
            N_n = floor(size(intNum,2)/(nChan));
            frmPerExc = floor(L_n/nExc);
        else
            N_n = floor(size(intNum,2)/(nExc*nChan));
            frmPerExc = L_n;
        end

        if isdFRET
            nFRET = size(dfretNum,2);
            if ~isempty(FRET) && nFRET~=size(FRET,1)
                updateActPan(['Unable to load discretized FRET from file: ' ...
                    fname{i} '\nThe number of FRET pairs is not ',...
                    'consistent with the correction factor files.'], h_fig, ...
                    'error');
                s = [];
                return
            elseif isempty(FRET) && row1>1
                FREThead = fdat(row1-1,:);
                FRET = getFRETfromFactorFiles(...
                    FREThead(colseq1:(colseqskip+1):colseq2));
            end
            if isempty(FRET) || sum(sum(isnan(FRET)))
                FRET = [];
                for don = 1:nChan
                    for acc = (don+1):nChan
                        FRET = cat(1,FRET,[don,acc]);
                    end
                end
                FRET = FRET(1:nFRET,:);
            end
        end
        
        % get differences in intensity-time traces length in current file
        % with previously imported and concatenated data
        if i==1
            frmPerExc_max = frmPerExc;
        else
            frmPerExc_max = max([frmPerExc frmPerExc_max]);
        end
        
        % format intensity data to a L-by-nMol*nChan-by-nExc matrix
        I = NaN(frmPerExc, nChan*N_n, nExc);
        for exc = 1:nExc
            if rowwise==1
                I(1:frmPerExc,:,exc) = intNum(exc:nExc:end,:);
            else
                id_exc = reshape(1:size(intNum,2),[nChan,nExc*N_n]);
                id_exc = id_exc(:,lasord(exc):nExc:end);
                I(1:frmPerExc,:,exc) = intNum(:,id_exc(:)');
            end
        end
        
        % extend missing length and fill with NaN
        I = cat(1,I,NaN(frmPerExc_max-frmPerExc,size(I,2),size(I,3)));
        
        
        if isdFRET
            if rowwise==1
                datdfret = NaN(frmPerExc, N_n*nFRET, nExc);
                exc = zeros(1,nFRET);
                for l = 1:nExc
                    datdfret(1:frmPerExc,:,l) = dfretNum(l:nExc:end,:);
                    for j = 1:nFRET
                        if ~all(isnan(datdfret(:,j:nFRET:end,l)))
                            exc(j) = l;
                        end
                    end
                end
                dFRET = NaN(frmPerExc, N_n*nFRET);
                for j = 1:nFRET
                    dFRET(:,j:nFRET:end) = datdfret(:,j:nFRET:end,exc(j));
                end
            else
                dFRET = dfretNum;
            end
        end
        
        if i==1
            % initialize boolean data (exclude data from first NaN encounter)
            for n = 1:N_n
                incl = cat(2,incl,...
                    ~isnan(sum(sum(I(:,nChan*(n-1)+1:nChan*n),3),2)));
            end
            
            % initialize concatenated data
            intensities = I;
            if isdFRET
                fret_DTA = dFRET;
            end
            old_incl = incl;
            old_i = intensities;
            
        else
            
            % extend existing missing boolean data with NaN
            incl = false(frmPerExc_max,size(old_incl,2));
            incl(1:size(old_incl,1),:) = old_incl;

            % calculate boolean data from alread-extended file's 
            % intensities and add to existing boolean data
            for n = 1:N_n
                incl = cat(2,incl,...
                    ~isnan(sum(sum(I(:,nChan*(n-1)+1:nChan*n),3),2)));
            end
            
            old_incl = incl;
            
            % extend existing missing intensity data with NaN
            intensities = NaN(frmPerExc_max,size(old_i,2),size(old_i,3));
            for l = 1:nExc
                intensities(1:size(old_i,1),:,l) = old_i(:,:,l);
            end
            
            % add file's already-extended intensities to existing 
            % intensities
            intensities = cat(2,intensities,I);
            old_i = intensities;
            
            % extend existing missing discretized FRETs and add file's
            % already-extended discretized FRETs
            if isdFRET
                old_dFRET = fret_DTA;
                fret_DTA = NaN(frmPerExc_max,size(old_dFRET,2)+size(dFRET,2));
                fret_DTA(1:size(old_dFRET,1),1:size(old_dFRET,2)) = ...
                    old_dFRET;
                fret_DTA(1:size(dFRET,1),(end-size(dFRET,2)+1):end) = dFRET;
            end
        end

        if all(all(isnan(I)))
            loading_bar('close', h_fig);
            updateActPan(['Unable to load intensity data from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            s = [];
            return
        end

        if isdFRET && all(all(isnan(fret_DTA)))
            loading_bar('close', h_fig);
            updateActPan(['Unable to load discretized FRET data from file:' ...
                ' ' fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            s = [];
            return
        end
        
        % import molecule coordinates from file's header
        coord_n = [];
        if coordintrace
            coordTxt = fdat(row_coord,:);
            coord_raw = [];
            for j = 1:size(coordTxt,1)
                c = str2double(coordTxt{j,1});
                if ~isempty(c) && size(c,2)==2
                    coord_raw = cat(1,coord_raw,c);
                end
            end
            for chan = 1:nChan
                coord_n(:,(2*chan-1):2*chan) = coord_raw(chan:nChan:end,:);
            end
            if isempty(coord_n)
                loading_bar('close', h_fig);
                updateActPan(['Molecule coordinates not found in file: ' ...
                    fname{i}], h_fig, 'error');
                s = [];
                return
            end
            
            if size(I,2)/nChan ~= size(coord_n,1)
                loading_bar('close', h_fig);
                updateActPan(['Number of intensity-time traces inconsistent ' ...
                    'with number of coordinates'], h_fig, 'error');
                s = [];
                return
            end
        end
        
        % add file's coordinates to existing coordinates
        coord = cat(1,coord,coord_n);

        if loading_bar('update', h_fig)
            return
        end
    end
        
catch err
    loading_bar('close', h_fig);
    updateActPan(['An error occurred during processing of file: ' ...
        fname{i} ':\n' err.message], h_fig, 'error');
    dispMatlabErr(err);
    s = [];
    return
end

N = size(intensities,2)/nChan;

if ~isempty(coord) && size(coord,1)~=N
    setContPan(['No coordinates imported: the number of intensity-time ',...
        'traces is inconsistent with the number of coordinates...'],...
        '', h_fig);
    cip = [];
    coordfile = '';
    coord = [];
end
if isGam && size(p{6}{3},1)~=N
    setContPan(['No gamma factor imported: the number of intensity-time ',...
        'traces is inconsistent with the number of gamma factors...'],...
        '', h_fig);
    p{6}{1} = '';
    p{6}{2} = {};
    p{6}{3} = [];
end
if isBet && size(p{6}{6},1)~=N
    setContPan(['No beta factor imported: the number of intensity-time ',...
        'traces is inconsistent with the number of beta factors...'],...
        '', h_fig);
    p{6}{4} = '';
    p{6}{5} = {};
    p{6}{6} = [];
end

if exptime~=s.frame_rate
    s.frame_rate = exptime;
    s.spltime_from_video = false;
end
s.pix_intgr = [1 1]; % intgr. area dim. + nb of intgr pix

s.is_coord = ~isempty(coord);
s.coord_file = coordfile; % coordinates path/file
s.coord_imp_param = cip; % coordinates import parameters
s.coord = coord; % molecule coordinates in all channels
s.coord_incl = true(1,N);

s.traj_import_opt = p;
s.bool_intensities = ~~incl;
s.intensities = intensities;
s.FRET = FRET;
s.FRET_DTA = fret_DTA;

loading_bar('close', h_fig);
