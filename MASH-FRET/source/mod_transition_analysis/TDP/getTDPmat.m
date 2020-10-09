function [TDP,dt_bin] = getTDPmat(dt, prm, varargin)
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
% "dt_bin" >> dwell time table excluding molecules without transitions

% Created the 29th of April 2014 by Mélodie C.A.S. Hadzic
% Last update: the 5th of May 2014 by Mélodie C.A.S. Hadzic

TDP = [];
dt_bin = [];

if ~isempty(varargin)
    h_fig = varargin{1};
else
    h_fig = [];
end

if ~sum(~cellfun(@isempty,dt))
    str = 'Not enough dwell-times to build a TDP.';
    if ~isempty(h_fig)
        setContPan(str, 'warning', h_fig);
    else
        disp(str);
    end
    return;
end

bins = prm{1};
lim = prm{2};
rate = prm{3};
oneval = prm{4};

% bin state values
str = 'Process: (1/2) binning the discrete values ...';
if ~isempty(h_fig);
    setContPan(str, 'process', h_fig);
else
    disp(str);
end

question = sprintf(cat(2,'Some transitions may lay out of TDP range. ',...
    'Should the outliers be ignored in state sequences?\n\n ',...
    'Outliers will be cut out form original state trajectories and ',...
    'neighbouring states will be linked together.'));
choice = questdlg(question, 'Re-arranged state sequence', ...
    'Yes', 'No,keep original dwell times', 'Yes');

if strcmp(choice, 'Yes')
    adj = 1;
    
elseif strcmp(choice, 'No,keep original dwell times')
    adj = 0;

else
    if ~isempty(h_fig)
        setContPan('Building TDP process was aborted.','warning',h_fig);
    else
        disp('Building TDP process was aborted.');
    end
    TDP = NaN;
    return;
end

iv_x = lim(1,1):bins(1):lim(1,2);
iv_y = lim(2,1):bins(2):lim(2,2);

trans = []; id_m  = [];
for m = 1:size(dt,1)
    if ~isempty(dt{m,1})
        
        % add molecule number in column 4 and columns 5,6 to add coordinates in TDP
        dat_m = [dt{m,1} ones(size(dt{m,1},1),1)*m zeros(size(dt{m,1},1),2)];
        
        % assign TDP x-coordinates in column 5
        [vals_x,o,id_x] = unique(dat_m(:,2));
        [o,id,o] = find(vals_x'>lim(1,1) & vals_x'<lim(1,2));
        vals_x(id,2) = id;
        dat_m(:,5) = vals_x(id_x',2);
        
        % assign TDP y-coordinates in column 6
        [vals_y,o,id_y] = unique(dat_m(:,3));
        [o,id,o] = find(vals_y'>lim(2,1) & vals_y'<lim(2,2));
        vals_y(id,2) = id;
        dat_m(:,6) = vals_y(id_y',2);
        
        % if x- or y-coordinates are out of TDP range, set coordinates to 0
        dat_m((dat_m(:,5)==0 | dat_m(:,6)==0),[5,6]) = 0;
        
        if adj
            % re-adjust state sequence by removing out-of-range states and
            % linking remaining states together
            dat_m = adjustDt(dat_m);
        end
        
        if ~isempty(dat_m)
            
            % bin dwell times to frame rate
            dat_m(:,1) = round(dat_m(:,1)/rate)*rate;
            
            % get unique state transitions and their indexes in 
            % concatenated table
            [trans_m,o,ids] = unique(dat_m(:,2:3), 'rows');
            id_m = cat(2,id_m,ids'+size(trans,1));
            trans = cat(1,trans,trans_m);
            
            % concatenate molecule dwell time tables and add column 7 and 8
            % for cluster appartenance.
            dt_bin = cat(1,dt_bin,[dat_m(:,1:4),zeros(size(dat_m,1),2)]);
        end
    end
end

if isempty(dt_bin)
    str = 'Not enough dwell-times to build a TDP.';
    if ~isempty(h_fig)
        setContPan(str, 'warning', h_fig);
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
        [TDP,o,o,coord] = hist2(trans(:,[1 2]),iv_x,iv_y);
        trans(:,[3 4]) = coord;
        dt_bin(:,[5 6]) = trans(id_m,[3 4]);
    else
        [TDP,o,o,coord] = hist2(dt_bin(:,[2 3]),iv_x,iv_y);
        dt_bin(:,[5 6]) = coord;
    end
    TDP(~~eye(size(TDP))) = 0;
    
catch err
    if ~isempty(h_fig)
        setContPan(cat(2,'Impossible to create TDP: ',err.message,...
            '\nIncreasing TDP binning might be a solution.'),'warning',...
            h_fig);
    else
        disp(sprintf(cat(2,'Impossible to create TDP: ',err.message,...
            '\nIncreasing TDP binning might be a solution.')));
    end
    return;
end

str = 'TDP successfully plotted.';
if ~isempty(h_fig);
    setContPan(str, 'success', h_fig);
else
    disp(str);
end



