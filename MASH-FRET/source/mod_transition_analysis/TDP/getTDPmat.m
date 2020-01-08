function [TDP,dt_bin] = getTDPmat(dt,prm,h_fig)
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

% initialize results
TDP = [];
dt_bin = [];

% abort if no transitions are available
if ~sum(~cellfun(@isempty,dt))
    str = 'Not enough dwell-times to build a TDP.';
    setContPan(str, 'warning', h_fig);
    TDP = NaN;
    return;
end

% collect project parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tag = p.curr_tag(proj);
m_incl = p.proj{proj}.coord_incl;
nMol = size(m_incl,2);

% collect plot parameters
bins = prm{1};
lim = prm{2};
rate = prm{3};
oneval = prm{4}(1);
adj = prm{4}(2);

% get molecule indexes
mols = 1:nMol;
if tag==1
    mols = mols(m_incl);
else
    molTag = p.proj{proj}.molTag;
    mols = mols(m_incl & molTag(:,tag-1)');
end

% bin state values
setContPan('Process: (1/2) binning the discrete values ...','process',...
    h_fig);

iv = lim(1,1):bins(1):lim(1,2);

trans = []; id_m  = [];
for m = mols
    
    if isempty(dt{m,1})
        continue
    end
        
    % add molecule number in column 4 and columns 5,6 to add coordinates in TDP
    dat_m = [dt{m,1} ones(size(dt{m,1},1),1)*m zeros(size(dt{m,1},1),2)];

    % assign TDP x-coordinates in column 5
    [vals_x,o,id_x] = unique(dat_m(:,2));
    [o,id,o] = find(vals_x'>lim(1,1) & vals_x'<lim(1,2));
    vals_x(id,2) = id;
    dat_m(:,5) = vals_x(id_x',2);

    % assign TDP y-coordinates in column 6
    [vals_y,o,id_y] = unique(dat_m(:,3));
    [o,id,o] = find(vals_y'>lim(1,1) & vals_y'<lim(1,2));
    vals_y(id,2) = id;
    dat_m(:,6) = vals_y(id_y',2);

    dat_m(end,[3,6]) = dat_m(end,[2,5]);

    if adj
        % re-adjust state sequence by removing out-of-range states and
        % linking remaining states together
        dat_m = adjustDt(dat_m);
    end

    if isempty(dat_m)
        continue
    end

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

if isempty(dt_bin)
    str = 'Not enough dwell-times to build a TDP.';
    setContPan(str, 'warning', h_fig);
    return;
end

setContPan('Process: (2/2) building the transition 2D plot...','process',...
    h_fig);

% count and store transition occurences in TDP matrix
try
    if oneval
        [TDP,o,o,coord] = hist2(trans(:,[1 2]),iv,iv);
        dt_bin(:,[5 6]) = coord(id_m,:);
    else
        [TDP,o,o,coord] = hist2(dt_bin(:,[2 3]),iv,iv);
        dt_bin(:,[5 6]) = coord;
    end
%     TDP(~~eye(size(TDP))) = 0;
    
catch err
    setContPan(cat(2,'Impossible to create TDP: ',err.message,...
        '\nIncreasing TDP binning might be a solution.'),'warning',h_fig);
    return
end

setContPan('TDP successfully plotted.', 'success', h_fig);



