function [TDP dt_bin] = getTDPmat(dt, prm, varargin)
% TDP = getTDPmat(dt, p, excl, h_fig)
%
% Build TDP matrix from input dwell-times and parameters
% "dt" >> {nMol-by-(nChan*nExc+nFRET+nS)} cell array containing:
%      {..,i} intensity dwell-times of each of the nChan channels upon each
%      of the nExc excitation wavelength (i C [1;nChan*nExc])
%      {..,j} FRET dwell-times of the nFRET different transfer calculations
%      (j C [(nChan*nExc+1);(nChan*nExc+nFRET)])
%      {..,k} stoichiometry dwell-times of the nS different stoichiometry 
%      calculations (k C [(nChan*nExc+nFRET+1);(nChan*nExc+nFRET+nS)])
%         Dwell-time arrays are [N-by-3] matrices containing:
%      (..,1) duration of the N dwell-times
%      (..,2) value of the N static states
%      (..,3) value of the states after the N transitions
% "p" >> structure containing 2D binning parameters
% "tpe" >> data type for which the TDP has to be built: 
%        intensity(i) or FRET(j) or stoichiometry(k))
% "excl" >> string "Exclude" if the first + last dwell-times are exlcuded
%        or string "Include" if the first dwell-time is included.
% "h_fig" >> MASH figure handle
% "TDP" >> TDP matrix built from input dwell-times

% Created the 29th of April 2014 by Mélodie C.A.S. Hadzic
% Last update: the 5th of May 2014 by Mélodie C.A.S. Hadzic

bins = prm{1};
lim = prm{2};
rate = prm{3};
oneval = prm{4};

TDP = [];
if ~isempty(varargin)
    h_fig = varargin{1};
else
    h_fig = [];
end

% bin state values
str = 'Process: (1/2) binning the discrete values ...';
if ~isempty(h_fig);
    setContPan(str, 'process', h_fig);
else
    disp(str);
end

iv_x = lim(1,1):bins(1):lim(1,2);
iv_y = lim(2,1):bins(2):lim(2,2);

dt_bin = []; trans = []; id_m  = [];
for m = 1:size(dt,1)
    if ~isempty(dt{m,1})
        % add molecule nunmber and exclude out-of range transitions
        dat_m = [dt{m,1} ones(size(dt{m,1},1),1)*m zeros(size(dt{m,1},1),2)];
        
        [vals_x,o,id_x] = unique(dat_m(:,2));
        [o,id,o] = find(vals_x'>lim(1,1) & vals_x'<lim(1,2));
        vals_x(id,2) = id;
        dat_m(:,5) = vals_x(id_x',2);
        
        [vals_y,o,id_y] = unique(dat_m(:,3));
        [o,id,o] = find(vals_y'>lim(2,1) & vals_y'<lim(2,2));
        vals_y(id,2) = id;
        dat_m(:,6) = vals_y(id_y',2);
        
        dat_m((dat_m(:,5)==0 | dat_m(:,6)==0),[5 6]) = 0;
        
        % re-adjust transition sequence
        dat_m = adjustDt(dat_m);
        
        if ~isempty(dat_m)
            dat_m(:,1) = round(dat_m(:,1)/rate)*rate;
            
            [trans_m,o,ids] = unique(dat_m(:,2:3), 'rows');
            id_m = [id_m ids'+size(trans,1)];
            trans = [trans;trans_m];
            
            dt_bin = [dt_bin; dat_m(:,1:4) zeros(size(dat_m,1),2)];
        end
    end
end

if isempty(dt_bin)
    str = 'Not enough dwell-times to build a TDP.';
    if ~isempty(h_fig)
        setContPan(str, 'error', h_fig);
    else
        disp(str);
    end
    return;
end

str = 'Process: (2/2) building the transition 2D plot...';
if ~isempty(h_fig)
    setContPan(str, 'process', h_fig);
else
    disp(str);
end

% count and store transition occurences in TDP matrix
try
    if oneval
        [TDP,o,o,coord] = hist2(trans(:,[1 2]),[iv_x;iv_y]);
        trans(:,[3 4]) = coord;
        dt_bin(:,[5 6]) = trans(id_m,[3 4]);
    else
        [TDP,o,o,coord] = hist2(dt_bin(:,[2 3]),[iv_x;iv_y]);
        dt_bin(:,[5 6]) = coord;
    end
    TDP(~~eye(size(TDP))) = 0;
    
catch err
    h_err = errordlg({['Impossible to create TDP: ' err.message] '' ...
        'Increasing TDP binning might be a solution.'}, 'TDP error', ...
        'modal');
    uiwait(h_err);
    return;
end

str = 'TDP successfully plotted.';
if ~isempty(h_fig);
    setContPan(str, 'success', h_fig);
else
    disp(str);
end



