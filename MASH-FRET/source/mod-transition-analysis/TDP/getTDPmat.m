function [TDP,dt_bin,ok,str] = getTDPmat(tpe, tag, prm, p_proj)
% Build TDP matrix from dwell-times
%
% [TDP,dt_bin,ok,str] = getTDPmat(tpe, tag, prm, p_proj)
%
% dt: {N-by-(nChan*nExc+nFRET+nS)} cell array containing:
%  columns 1 to nChan*nExc: intensity dwell-times
%  columns nChan*nExc+1 to nChan*nExc+nFRET: FRET dwell-times
%  columns nChan*nExc+nFRET+1 to nChan*nExc+nFRET+nS stoichiometry dwell-times
%  Dwell-time [D-by-3] arrays containing [dwell-times (in seconds), state before transition, state after transition]
% prm: vector containing TDP parameters
% tag: molecule subgroup
% h_fig: MASH figure handle
%
% TDP: TDP matrix built from input dwell-times
% dt_bin: dwell time table excluding molecules without transitions

% Last update by MH, 26.1.2020: add option to include/exclude diagonal densities (last state in sequence)
% update by MH, 5.5.2014
% created by MH, 29.4.2014

% initialize results
TDP = [];
dt_bin = [];
ok = 0;
str = '';

% collect project parameters
dt = p_proj.dt(:,tpe);
m_incl = p_proj.coord_incl;
molTag = p_proj.molTag;
expT = p_proj.frame_rate;

% abort if no transitions are available
if ~sum(~cellfun(@isempty,dt))
    str = 'Not enough dwell-times to build a TDP.';
    TDP = NaN;
    return
end

% collect plot parameters
bin = prm(1);
lim = prm(2:3);
oneval = prm(4);
adj = prm(5);
incldiag = prm(6);

if lim(1)==lim(2) || bin==0
    str = 'TDP limits or bin size are ill-defined.';
    return
end

% get molecule indexes
N = size(m_incl,2);
mols = 1:N;
if tag==1
    mols = mols(m_incl);
else
    mols = mols(m_incl & molTag(:,tag-1)');
end

% bin state values
iv = lim(1):bin(1):lim(2);

trans = []; id_m  = [];
for m = mols
    if isempty(dt{m,1})
        continue
    end
        
    % add molecule number in column 4 and columns 5,6 to add coordinates in TDP
    dat_m = [dt{m,1} ones(size(dt{m,1},1),1)*m zeros(size(dt{m,1},1),2)];

    % assign TDP x-coordinates in column 5
    [vals_x,o,id_x] = unique(dat_m(:,2));
    [o,id,o] = find(vals_x'>lim(1) & vals_x'<lim(2));
    vals_x(id,2) = id;
    dat_m(:,5) = vals_x(id_x',2);

    % assign TDP y-coordinates in column 6
    [vals_y,o,id_y] = unique(dat_m(:,3));
    [o,id,o] = find(vals_y'>lim(1) & vals_y'<lim(2));
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
    dat_m(:,1) = round(dat_m(:,1)/expT)*expT;

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
    return
end

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
    str = cat(2,'Impossible to create TDP: ',err.message,'\nIncreasing ',...
        'TDP binning might be a solution.');
    return
end

if ~incldiag
    TDP(~~eye(size(TDP))) = 0;
    dt_bin(dt_bin(:,5)==dt_bin(:,6),[5,6]) = 0;
end

ok = 1;


