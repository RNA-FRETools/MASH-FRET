function s = intAscii2mash(pname, fname, p, h_fig)

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
isdFRET = p{1}{1}(9); col_dFRET = p{1}{1}(10);

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
    [data ok] = getFrames(mov_file, 1, {}, h_fig);
    if ~ok
        return;
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
    coord_tot = orgCoordCol(importdata(coord_file, '\n'), 'cw', ...
        coord_imp, nChan, res_x);
else
    coord_imp = [];
    coord_file = [];
    coord_tot = [];
    if coordInTrace
        row_coord = p{4}(2);
    end
end

intensities = [];
incl = [];
fret_DTA = [];
if isTime
    colTime = p{1}{1}(4);
else
    frame_rate = 1;
end

try
    for i = 1:size(fname,2)
        f = fopen([pname fname{i}], 'r');
        fDat = textscan(f, '%s', 'delimiter', '\n');
        fclose(f);
        fDat = fDat{1};

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
        intNum = [];
        dFRET = [];
        for r = row_start:r_end
            dat = str2num(fDat{r,1});
            if ~isempty(dat)
                if isTime && i == 1
                    times(size(times,1)+1,1) = dat(1,colTime);
                end
                if isdFRET
                    dFRET(size(dFRET,1)+1,:) = ...
                        dat(1,col_dFRET:col_dFRET:end);
                end
                intNum(size(intNum,1)+1,:) = dat(1,col_start:c_end);
            end
        end
        
        if isempty(intNum)
            loading_bar('close', h_fig);
            updateActPan(['Unable to load intensity data from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            return;
        end

        nMol = floor(size(intNum,2)/(nChan));
        zTot = size(intNum,1);
        frmPerExc = floor(zTot/nExc);
        if i==1
            frmPerExc_max = frmPerExc;
        else
            frmPerExc_max = max([frmPerExc frmPerExc_max]);
        end
        
        I = NaN(frmPerExc, nChan*nMol, nExc);
        for exc = 1:nExc
            I(1:frmPerExc,:,exc) = intNum(exc:nExc:end,:);
        end
        I = cat(1,I,NaN(frmPerExc_max-frmPerExc,size(I,2),size(I,3)));
        
        if isdFRET
            dFRET = cat(1,dFRET(exc:nExc:end,:), ...
                false(frmPerExc_max-frmPerExc,nMol));
        end
        
        if i==1
            incl = true(frmPerExc,1);
            intensities = I;
            if isdFRET
                fret_DTA = dFRET;
            end
            old_incl = incl;
            old_i = intensities;
            
        else
            incl = false(frmPerExc_max,size(old_incl,2));
            incl(1:size(old_incl,1),:) = old_incl;
            incl = cat(2,incl,cat(1,true(frmPerExc,nMol),false(frmPerExc_max-frmPerExc,nMol)));
            old_incl = incl;
            
            intensities = NaN(frmPerExc_max,size(old_i,2),size(old_i,3));
            for l = 1:exc
                intensities(1:size(old_i,1),:,l) = old_i(:,:,l);
            end
            intensities = cat(2,intensities,I);
            old_i = intensities;
            
            if isdFRET
                old_dFRET = fret_DTA;
                fret_DTA = NaN(frmPerExc_max,size(old_dFRET,2));
                fret_DTA(1:size(old_dFRET,1),:) = old_dFRET;
                fret_DTA = cat(2,fret_DTA,dFRET);
            end
        end
        
        if ~sum(sum(I(~isnan(I))))
            loading_bar('close', h_fig);
            updateActPan(['Unable to load intensity data from file: ' ...
                fname{i} '\nPlease check import options.'], h_fig, ...
                'error');
            return;
        end
        
        if isTime && i == 1
            frame_rate = times(2) - times(1);
        end
        
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
                updateActPan(['Unable to load coordinates data from ' ...
                    'file: ' fname{i}], h_fig, 'error');
                return;
            end
        end

        if isCoord && size(I,2)/nChan ~= size(coord,1)
            updateActPan(['Number of intensity-time traces inconsistent' ...
                'with number of molecules'], 'h_fig', 'error');
            return;
        end

        coord_tot = [coord_tot;coord];
        
        intrupt = loading_bar('update', h_fig);
        if intrupt
            return;
        end
    end
        
catch err
    updateActPan(['An error occurred during processing of file: ' ...
        fname{i} ':\n' err.message], h_fig, 'error');
    disp(err.message);
    disp(['function: ' err.stack(1,1).name ', line: ' ...
        num2str(err.stack(1,1).line)]);
    return;
end


s.date_creation = datestr(now);
s.date_last_modif = s.date_creation;
s.MASH_version = getValueFromStr('MASH smFRET ', ...
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
s.frame_rate = frame_rate;
s.excitations = wl; % laser wavelengths (chronological order)
s.nb_excitations = numel(wl);
s.pix_intgr = [1 1]; % intgr. area dim. + nb of intgr pix
s.cnt_p_pix = 1; % intensities in counts per pixels
s.cnt_p_sec = 0; % intensities in counts per second
if isdFRET
    s.FRET = [1 2];
else
    s.FRET = [];
end
s.S = [];

s.chanExc = zeros(1,nChan);
for c = 1:nChan
    s.labels{c} = sprintf('chan%i', c);
    if c <= s.nb_excitations
        s.chanExc(c) = s.excitations(c);
    end
end

nS = 0;

s.intensities = intensities;
s.intensities_bgCorr = intensities;
s.intensities_crossCorr = intensities;
s.intensities_denoise = intensities;
s.intensities_DTA = nan(size(intensities));
s.FRET_DTA = fret_DTA;
s.S_DTA = nan([size(intensities,1) nS*nMol]);
s.bool_intensities = ~~incl;


