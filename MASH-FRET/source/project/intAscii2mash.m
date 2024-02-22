function s = intAscii2mash(pname, fname, s, p, h_fig)

% Last update, 8.4.2019 by MH: fix errors occurring when improting discretized FRET traces
% update, 3.4.2019 by MH: (1) correct boolean data according to each molecule's NaN (2) correct discretized FRET import for more than one laser excitation: import FRET data at donor excitation, fill missing discretized FRET data with NaNs instead of falses and manage import failure. (2) change "sampling_time" name to "exptime"
% update 28.3.2019 by MH: (1) Display all function and code line when an error occurs (2) Fix error when importing coordinates from file (3) Manage error when importing a number of coordinates from file different from number of intensity-time traces

% defaults
% coordintrace = false;
bufferSz = 1e3;

% check loading bar
islb = size(fname,2)>1;

% collect project parameters
exptime = s.sampling_time;
nChan = s.nb_channel;
nExc = s.nb_excitations;
cip = s.coord_imp_param;
coordfile = s.coord_file;
coord = s.coord;
FRET = s.FRET;

row1 = p{1}{1}(1)+1;
delim = p{1}{1}(2);
isTime = p{1}{1}(3);
rowwise = p{1}{1}(5);
isdFRET = p{1}{1}(6);
onemol = p{1}{1}(7);
icol = p{1}{3};
icol_exc = p{1}{4};
fretcol = p{1}{5};
isGam = sum(p{6}{1}) & ~isempty(p{6}{2});
isBet = sum(p{6}{4}) & ~isempty(p{6}{5});

colI1 = icol(:,1);
colI2 = icol(:,2);
colIiv = icol(:,3)+1;
colseq1 = fretcol(:,1);
colseq2 = fretcol(:,2);
colseqiv = fretcol(:,3)+1;

if rowwise==2
    colI1 = icol_exc(:,1,:);
    colI2 = icol_exc(:,2,:);
    colIiv = icol_exc(:,3,:)+1;
end

nPair = size(FRET,1);
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
        p{6}{3} = cat(1,p{6}{3},zeros(size(content,1),nPair));
        for pair = 1:nPair
            col = pairs(:,1)==FRET(pair,1) & pairs(:,2)==FRET(pair,2);
            p{6}{3}(end-size(content,1)+1:end,pair) = content(:,col');
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
        p{6}{6} = cat(1,p{6}{6},zeros(size(content,1),nPair));
        for pair = 1:nPair
            col = pairs(:,1)==FRET(pair,1) & pairs(:,2)==FRET(pair,2);
            p{6}{6}(end-size(content,1)+1:end,pair) = content(:,col');
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
        
        % read file
        dat = [];
        f = fopen([pname fname{i}], 'r');
        if i==1
            for line = 1:(row1-1)
                fgetl(f);
            end
            str = split(fgetl(f),delimchar)';
            excl = false(1,numel(str));
            for col = 1:numel(str)
                chars = unique(str{col});
                if numel(chars)==0 || (numel(chars)==1 && chars==' ')
                    excl(col) = true;
                end
            end
            str(excl) = [];
            nCol = numel(str);
            frewind(f);
        end
        for line = 1:(row1-1)
            fgetl(f);
        end
        scdat = reshape(fscanf(f,...
            ['%f',repmat(' %f',[1,nCol-1]),'\n'],nCol*bufferSz),nCol,...
            [])' ;
        while ~isempty(scdat)
            if ~isempty(dat) && size(scdat,2)~=size(dat,2)
                if size(scdat,2)<size(dat,2)
                    scdat = cat(2,scdat,...
                        cell(1,size(dat,2)-size(scdat,2)));
                else
                    dat = cat(2,dat,...
                        cell(size(dat,1),size(scdat,2)-size(dat,2)));
                end
            end
            dat = cat(1,dat,scdat);
            scdat = reshape(fscanf(f,...
                ['%f',repmat(' %f',[1,nCol-1]),'\n'],nCol*bufferSz),...
                nCol,[])' ;
        end
        fclose(f);
        
        % collect import parameters
        nCol = size(dat,2);
        colI1(colI1==0) = nCol;
        colI2(colI2==0) = nCol;
        colseq1(colseq1==0) = nCol;
        colseq2(colseq2==0) = nCol;
        
        % get time information from first file
        if isTime && i==1
            times = dat(:,colt);
        
            % get exposure time and laser order
            if rowwise==1
                exptime = abs(times(2)-times(1));
                lasord = 1:nExc;
            else
                [tfirstexc,lasord] = sort(times(1,:));
                exptime = abs(tfirstexc(2)-tfirstexc(1));
            end
        end
        
        % get FRET state sequences from file
        dfretNum = [];
        if isdFRET
            if onemol
                colseq = colseq1(:,1)';
            else
                colseq = [];
                for pair = 1:nPair
                    colseqrange = ...
                        colseq1(pair):colseqiv(pair):colseq2(pair);
                    if ~isempty(colseq) && ...
                            numel(colseqrange)~=size(colseq,2)
                        setContPan(['Unable to load FRET state sequences ',...
                            'from file: ' fname{i} '\nThe numbers of ',...
                            'sequences for each FRET pair are different ',...
                            'when they should all be equal to the number ',...
                            'of molecules in the file.\nPlease correct ',...
                            'the import options and try again.'],'error',...
                            h_fig);
                        s = [];
                        return
                    end
                    colseq = cat(1,colseq,colseqrange);
                end
                colseq = reshape(colseq,1,[]);
            end
            dfretNum = dat(:,colseq);
        end
        if isdFRET && isempty(dfretNum)
            setContPan(['Unable to load discretized FRET from file: ' ...
                fname{i} '\nPlease check import options.'],'error', h_fig);
            s = [];
            return
        end
        
        % get intensity trajectories from file
        intNum = [];
        for l = 1:size(colI1,3)
            if onemol
                colIl = colI1(:,1,l);
            else
                colIl = [];
                for c = 1:size(colI1,1)
                    colIrange = colI1(c,1,l):colIiv(c,1,l):colI2(c,1,l);
                    if ~isempty(colIl) && numel(colIrange)~=size(colIl,2)
                        setContPan(['Unable to load intensity trajectories ',...
                            'from file: ' fname{i} '\nThe numbers of ',...
                            'trajectories for each channel are different ',...
                            'when they should all be equal to the number ',...
                            'of molecules in the file.\nPlease correct ',...
                            'the import options and try again.'],'error',...
                            h_fig);
                        s = [];
                        return
                    end
                    colIl = cat(1,colIl,colIrange);
                end
            end
            colIl = reshape(colIl,1,[]);
            if ~isempty(intNum) && size(intNum,2)~=size(colIl,2)
                setContPan(['Unable to load intensity trajectories ',...
                    'from file: ' fname{i} '\nThe numbers of trajectories',...
                    ' for each laser illumination are different ',...
                    'when they should all be equal to the number ',...
                    'of molecules in the file.\nPlease correct ',...
                    'the import options and try again.'],'error',...
                    h_fig);
                s = [];
                return
            end
            intNum = cat(3,intNum,dat(:,colIl));
        end
        if isempty(intNum)
            loading_bar('close', h_fig);
            setContPan(['Unable to load intensity data from file: ' ...
                fname{i} '\nPlease check import options.'],'error', h_fig);
            s = [];
            return
        end
        
        % format intensities in file to a L-by-N*nChan-by-nExc matrix
        % with correct lasre order
        L_fle = size(intNum,1);
        N_fle = floor(size(intNum,2)/nChan);
        if rowwise==1
            frmPerExc = floor(L_fle/nExc);
        else
            frmPerExc = L_fle;
        end
        I = NaN(frmPerExc,nChan*N_fle,nExc);
        for exc = 1:nExc
            if rowwise==1
                I(1:frmPerExc,:,exc) = intNum(exc:nExc:end,:);
            else
                I(1:frmPerExc,:,exc) = intNum(:,:,lasord(exc));
            end
        end
        
        % format FRET state sequences in file to a L-by-N*nFRET matrix
        if isdFRET
            if rowwise==1
                datdfret = NaN(frmPerExc, N_fle*nPair, nExc);
                exc = zeros(1,nPair);
                for l = 1:nExc
                    datdfret(1:frmPerExc,:,l) = dfretNum(l:nExc:end,:);
                    for j = 1:nPair
                        if ~all(isnan(datdfret(:,j:nPair:end,l)))
                            exc(j) = l;
                        end
                    end
                end
                dFRET = NaN(frmPerExc, N_fle*nPair);
                for j = 1:nPair
                    dFRET(:,j:nPair:end) = datdfret(:,j:nPair:end,exc(j));
                end
            else
                dFRET = dfretNum;
            end
        end

        % correct differences in trace length with previous files
        if i==1
            frmPerExc_max = frmPerExc;
        else
            frmPerExc_max = max([frmPerExc frmPerExc_max]);
        end
        I = cat(1,I,NaN(frmPerExc_max-frmPerExc,size(I,2),size(I,3)));
        if isdFRET
            dFRET = cat(1,dFRET,NaN(frmPerExc_max-frmPerExc,size(dFRET,2)));
        end
        
        if i==1
            % initialize boolean data (exclude data from first NaN encounter)
            for n = 1:N_fle
                incl = cat(2,incl,...
                    ~isnan(sum(sum(I(:,nChan*(n-1)+1:nChan*n),3),2)));
            end
            old_incl = incl;
            
            % initialize concatenated data
            intensities = I;
            old_i = intensities;
            
            if isdFRET
                fret_DTA = dFRET;
                old_dFRET = fret_DTA;
            end
        else
            
            % extend existing missing boolean data with NaN
            incl = false(frmPerExc_max,size(old_incl,2));
            incl(1:size(old_incl,1),:) = old_incl;

            % calculate boolean data from alread-extended file's 
            % intensities and add to existing boolean data
            for n = 1:N_fle
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
                fret_DTA = NaN(frmPerExc_max,size(old_dFRET,2)+size(dFRET,2));
                fret_DTA(1:size(old_dFRET,1),1:size(old_dFRET,2)) = ...
                    old_dFRET;
                fret_DTA(1:size(dFRET,1),(end-size(dFRET,2)+1):end) = dFRET;
                old_dFRET = fret_DTA;
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
        
%         % import molecule coordinates from file's header
%         coord_n = [];
%         if coordintrace
%             coordTxt = dat(row_coord,:);
%             coord_raw = [];
%             for j = 1:size(coordTxt,1)
%                 c = str2double(coordTxt{j,1});
%                 if ~isempty(c) && size(c,2)==2
%                     coord_raw = cat(1,coord_raw,c);
%                 end
%             end
%             for chan = 1:nChan
%                 coord_n(:,(2*chan-1):2*chan) = coord_raw(chan:nChan:end,:);
%             end
%             if isempty(coord_n)
%                 loading_bar('close', h_fig);
%                 updateActPan(['Molecule coordinates not found in file: ' ...
%                     fname{i}], h_fig, 'error');
%                 s = [];
%                 return
%             end
%             
%             if size(I,2)/nChan ~= size(coord_n,1)
%                 loading_bar('close', h_fig);
%                 updateActPan(['Number of intensity-time traces inconsistent ' ...
%                     'with number of coordinates'], h_fig, 'error');
%                 s = [];
%                 return
%             end
%         end
%         
%         % add file's coordinates to existing coordinates
%         coord = cat(1,coord,coord_n);

        if islb && loading_bar('update', h_fig)
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

if exptime~=s.sampling_time
    s.sampling_time = exptime;
    s.spltime_from_video = false;
end
s.pix_intgr = [1 1]; % intgr. area dim. + nb of intgr pix

s.folderRoot = pname;
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
s.FRET_DTA_import = fret_DTA;

loading_bar('close', h_fig);
