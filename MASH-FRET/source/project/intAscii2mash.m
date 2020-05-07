function s = intAscii2mash(pname, fname, p, h_fig)

% Last update, 8.4.2019 by MH: fix errors occurring when improting discretized FRET traces
% update, 3.4.2019 by MH: (1) correct boolean data according to each molecule's NaN (2) correct discretized FRET import for more than one laser excitation: import FRET data at donor excitation, fill missing discretized FRET data with NaNs instead of falses and manage import failure. (2) change "frame_rate" name to "exptime"
% update 28.3.2019 by MH: (1) Display all function and code line when an error occurs (2) Fix error when importing coordinates from file (3) Manage error when importing a number of coordinates from file different from number of intensity-time traces

s = [];

if size(p{1}{1},2)==8
    p{1}{1}(9) = 0;
    p{1}{1}(10) = 5;
end

isMov = p{2}{1};

isCoordFile = p{3}{1}; 
coordInTrace = p{4}(1);
isCoord = isCoordFile + coordInTrace;

isTime = p{1}{1}(3);
row_start = p{1}{1}(1); row_end = p{1}{1}(2);
col_start = p{1}{1}(5); col_end = p{1}{1}(6);
nChan = p{1}{1}(7);
nExc = p{1}{1}(8); wl = p{1}{2}(1:nExc);
isdFRET = p{1}{1}(9);
col_seq_start = p{1}{1}(10); col_seq_end = p{1}{1}(11);
col_seq_skip = p{1}{1}(12);
isGam = p{6}{1} & sum(p{6}{2}) & ~isempty(p{6}{3});
isBet = p{6}{4} & sum(p{6}{5}) & ~isempty(p{6}{6}) ;

% det default project parameters
FRET = [];

exp_param = {'Movie name' '' ''
    'Molecule name' '' ''
    '[Mg2+]' [] 'mM'
    '[K+]' [] 'mM'};
for i = 1:nExc
    exp_param{size(exp_param,1)+1,1} = ['Power(' ...
        num2str(round(wl(i))) 'nm)'];
    exp_param{size(exp_param,1),2} = '';
    exp_param{size(exp_param,1),3} = 'mW';
end

% movie
if isMov
    mov_file = p{2}{2};
    [data ok] = getFrames(mov_file, 1, {}, h_fig, false);
    if ~ok
        return
    end
    mov_dim = [data.pixelX data.pixelY];
    fCurs = data.fCurs;
else
    mov_file = [];
    mov_dim = [];
    fCurs = [];
end

% coordinates
if isCoord && isCoordFile
    coord_imp = p{3}{3};
    coord_file = p{3}{2};
    res_x = p{3}{4};
    coord_tot = orgCoordCol(importdata(coord_file,'\n'),...
        'cw',coord_imp,nChan,res_x,h_fig);
else
    coord_imp = [];
    coord_file = [];
    coord_tot = [];
    if coordInTrace
        row_coord = p{4}(2);
    end
end

if isGam
    gam_folder = p{6}{2};
    gam_file_1 = p{6}{3};
    content = importdata(cat(2,gam_folder,gam_file_1{1}));
    if isstruct(content)
        pairs = getFRETfromFactorFiles(content.colheaders);
        if ~isempty(pairs)
            FRET = pairs;
        end
    end
end

if isBet
    bet_folder = p{6}{5};
    bet_file_1 = p{6}{6};
    content = importdata(cat(2,bet_folder,bet_file_1{1}));
    if isstruct(content)
        pairs = getFRETfromFactorFiles(content.colheaders);
        if ~isempty(pairs)
            if isempty(FRET) || (~isempty(FRET) && ~isequal(pairs,FRET))
                FRET = pairs;
            end
        end
    end
end

intensities = [];
incl = [];
fret_DTA = [];
if isTime
    colTime = p{1}{1}(4);
else
    exptime = 1;
end

try
    for i = 1:size(fname,2)
        
        % read file
        f = fopen([pname fname{i}], 'r');
        fDat = textscan(f, '%s', 'delimiter', '\n');
        fclose(f);
        fDat = fDat{1};
        
        % collect import parameters
        if row_end == 0
            r_end = size(fDat,1);
        else
            r_end = row_end;
        end
        if col_end == 0
            c_end = size(str2num(fDat{row_start,1}),2);
        else
            c_end = col_end;
        end
        if isTime && i == 1
            times = [];
        end
        
        % format intensity and discretized data
        intNum = [];
        
        % modified by MH, 3.4.2019
        % dFRET = [];
        dfretNum = [];
        
        for r = row_start:r_end
            dat = str2num(fDat{r,1});
            if ~isempty(dat)
                if isTime && i == 1
                    times(size(times,1)+1,1) = dat(1,colTime);
                end
                if isdFRET
                    
                    % modified by MH, 3.4.2019
%                     dFRET(size(dFRET,1)+1,:) = ...
%                         dat(1,col_dFRET:col_dFRET:end);
                    dfretNum(size(dfretNum,1)+1,:) = ...
                        dat(1,col_seq_start:(col_seq_skip+1):col_seq_end);
                    
                end
                intNum(size(intNum,1)+1,:) = dat(1,col_start:c_end);
            end
        end
        
        if isempty(intNum)
            loading_bar('close', h_fig);
            updateActPan(['Unable to load intensity data from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            return
        end
        
        % added by MH, 3.4.2019
        % corrected by MH, 8.4.2019
        if isdFRET && isempty(dfretNum)
%         if isdFRET && ~isempty(dfretNum)
            updateActPan(['Unable to load discretized FRET from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            return
        end
        
        % get data dimensions
        nMol = floor(size(intNum,2)/(nChan));
        zTot = size(intNum,1);
        frmPerExc = floor(zTot/nExc);
        
        % added by MH, 3.4.2019
        if isdFRET
            nFRET = size(dfretNum,2);
            if ~isempty(FRET) && nFRET~=size(FRET,1)
                updateActPan(['Unable to load discretized FRET from file: ' ...
                    fname{i} '\nThe number of FRET pairs is not ',...
                    'consistent with the correction factor files.'], h_fig, ...
                    'error');
                return
            elseif isempty(FRET) && row_start>1
                FREThead = eval(cat(2,'{''',...
                    strrep(fDat{row_start-1,1},char(9),''','''),'''}'));
                FRET = getFRETfromFactorFiles(...
                    FREThead(col_seq_start:(col_seq_skip+1):col_seq_end));
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
        I = NaN(frmPerExc, nChan*nMol, nExc);
        for exc = 1:nExc
            I(1:frmPerExc,:,exc) = intNum(exc:nExc:end,:);
        end
        
        % extend missing length and fill with NaN
        I = cat(1,I,NaN(frmPerExc_max-frmPerExc,size(I,2),size(I,3)));
        
        
        if isdFRET
            
            % corrected by MH, 3.4.2019
%             dFRET = cat(1,dFRET(exc:nExc:end,:), ...
%                 false(frmPerExc_max-frmPerExc,nMol));
            % format discretized FRET data to a L-by-nMol*nFRET matrix
            datdfret = NaN(frmPerExc, nMol*nFRET, nExc);
            exc = zeros(1,nFRET);
            for l = 1:nExc
                datdfret(1:frmPerExc,:,l) = dfretNum(l:nExc:end,:);
                for j = 1:nFRET
                    if ~all(isnan(datdfret(:,j:nFRET:end,l)))
                        exc(j) = l;
                    end
                end
            end
            dFRET = NaN(frmPerExc, nMol*nFRET);
            for j = 1:nFRET
                dFRET(:,j:nFRET:end) = datdfret(:,j:nFRET:end,exc(j));
            end            
        end
        
        if i==1
            
            % removed by MH, 3.4.2019
%             incl = true(frmPerExc,1);
            
            % added by MH, 3.4.2019
            % initialize boolean data (exclude data from first NaN 
            % encounter)
            for n = 1:nMol
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

            % removed by MH, 3.4.2019
%             incl = cat(2,incl,cat(1,true(frmPerExc,nMol),false(frmPerExc_max-frmPerExc,nMol)));
            
            % added by MH, 3.4.2019
            % calculate boolean data from alread-extended file's 
            % intensities and add to existing boolean data
            for n = 1:nMol
                incl = cat(2,incl,...
                    ~isnan(sum(sum(I(:,nChan*(n-1)+1:nChan*n),3),2)));
            end
            
            old_incl = incl;
            
            % extend existing missing intensity data with NaN
            intensities = NaN(frmPerExc_max,size(old_i,2),size(old_i,3));
            
            % corrected by MH, 4.3.2019
%             for l = 1:exc
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
                fret_DTA = NaN(frmPerExc_max,size(old_dFRET,2)+1);
                fret_DTA(1:size(old_dFRET,1),1:size(old_dFRET,2)) = ...
                    old_dFRET;
                fret_DTA(1:size(dFRET,1),end) = dFRET;
            end
        end
        
        % modified by MH, 3.4.2019
%         if ~sum(sum(I(~isnan(I))))
        if all(isnan(I))
            
            loading_bar('close', h_fig);
            updateActPan(['Unable to load intensity data from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            return
        end
        
        % added by MH, 3.4.2019
        % corrected by MH, 8.4.2019
%         if isdFRET && all(isnan(fret_DTA))
        if isdFRET && all(all(isnan(fret_DTA)))
            loading_bar('close', h_fig);
            updateActPan(['Unable to load discretized FRET data from file:' ...
                ' ' fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            return
        end
        
        % get exposure time
        if isTime && i == 1
            exptime = abs(times(2) - times(1));
        end
        
        % import molecule coordinates from file's header
        coord = [];
        if isCoord && coordInTrace
            str_coord = fDat{row_coord,1};
            coordTxt = textscan(str_coord, '%s', 'delimiter', '\t');
            coordTxt = coordTxt{1};
            coord_raw = [];
            for j = 1:size(coordTxt,1)
                c = str2num(coordTxt{j,1});
                if ~isempty(c) && size(c,2) == 2
                    coord_raw(size(coord_raw,1)+1,1:2) = c;
                end
            end
            for chan = 1:nChan
                coord(:, (2*chan-1):2*chan) = coord_raw(chan:nChan:end,:);
            end
            if isempty(coord)
                loading_bar('close', h_fig);
                updateActPan(['Molecule coordinates not found in file: ' ...
                    fname{i}], h_fig, 'error');
                return
            end
            
            if size(I,2)/nChan ~= size(coord,1)
                updateActPan(['Number of intensity-time traces inconsistent ' ...
                    'with number of coordinates'], h_fig, 'error');
                return
            end
        end
        
        % add file's coordinates to existing coordinates
        coord_tot = [coord_tot;coord];
        
        intrupt = loading_bar('update', h_fig);
        if intrupt
            return
        end
    end
        
catch err
    updateActPan(['An error occurred during processing of file: ' ...
        fname{i} ':\n' err.message], h_fig, 'error');
    dispMatlabErr(err);
    return
end

if isCoord && size(intensities,2)/nChan ~= size(coord_tot,1)
    updateActPan(['Number of intensity-time traces inconsistent with ',...
        'number of coordinates'], h_fig, 'error');
    return
end

nS = 0;
nMol = size(fname,2);

s.date_creation = datestr(now);
s.date_last_modif = s.date_creation;
s.MASH_version = getValueFromStr('MASH-FRET ', ...
    get(h_fig, 'Name'));
s.exp_parameters = exp_param; % default parameters
[path,name,o] = fileparts(pname);
if isempty(name)
    [o,name,o] = fileparts(path);
end
s.proj_file = [pname name '.mash'];

s.movie_file = mov_file; % movie path/file
s.movie_dim = mov_dim;
s.movie_dat = {fCurs, mov_dim, size(intensities,1)*numel(wl)};

s.coord_file = coord_file; % coordinates path/file
s.coord_imp_param = coord_imp; % coordinates import parameters
s.coord = coord_tot; % molecule coordinates in all channels
s.coord_incl = true(1,size(intensities,2)/nChan);

s.nb_channel = nChan; % nb of channel
s.frame_rate = exptime;
s.excitations = wl; % laser wavelengths (chronological order)
s.nb_excitations = numel(wl);
s.pix_intgr = [1 1]; % intgr. area dim. + nb of intgr pix
s.cnt_p_pix = 1; % intensities in counts per pixels
s.cnt_p_sec = 0; % intensities in counts per second
s.FRET = FRET;
s.S = [];

s.chanExc = zeros(1,nChan);
for c = 1:nChan
    s.labels{c} = sprintf('chan%i', c);
    if c <= s.nb_excitations
        s.chanExc(c) = s.excitations(c);
    end
end

s.intensities = intensities;
s.intensities_bgCorr = intensities;
s.intensities_crossCorr = intensities;
s.intensities_denoise = intensities;
s.intensities_DTA = nan(size(intensities));

if isempty(fret_DTA) && size(FRET,1)>0
    fret_DTA = nan([size(intensities,1) size(FRET,1)*nMol]);
end
s.FRET_DTA = fret_DTA;

s.S_DTA = nan([size(intensities,1) nS*nMol]);
s.bool_intensities = incl;


