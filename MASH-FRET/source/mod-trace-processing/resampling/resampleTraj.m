function p = resampleTraj(m, p)

proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;
splt = p.proj{proj}.TP.fix{5};
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
splt0 = p.proj{proj}.sampling_time;
I0 = p.proj{proj}.intensities_bgCorr;

isBin = ~isempty(p.proj{proj}.intensities_bin) && ~all(sum(sum(isnan(...
    p.proj{proj}.intensities_bin(:,((m-1)*nC+1):m*nC,:)),2),3));
if isBin
    return
end

% gets molecule sample size
[nRow,nCol,nExc] = size(I0);
N = nCol/nC;
L = nRow*nExc;

% calculates ALEX sampling time
expt_alex = splt*nExc; % multiple time bin for ALEX data
expt0_alex = splt0*nExc; % multiple time bin for ALEX data
    
% formats data for time binning
framenb = reshape(1:L,nExc,nRow)';
dat = [];
colt = [];
for exc = 1:nExc
    colt = cat(2,colt,size(dat,2)+1);
    dat = cat(2,dat,[expt0_alex*framenb(:,exc),framenb(:,exc),...
        I0(:,((m-1)*nC+1):(nC*m),exc)]);
end

% bins data
dat = binData(dat,expt_alex,expt0_alex,colt,colt+1);
if isempty(dat)
    return
end

% formats binned data and appends project data
I = [];
for exc = 1:nExc
    I = cat(3,I,dat(:,((exc-1)*(nC+2)+3):(exc*(nC+2))));
end

% resets data in projects and processing parameters
[nRow,~] = size(I);
if size(p.proj{proj}.intensities_bin,1)~=nRow
    p.proj{proj}.intensities_bin = NaN(nRow,N*nC,nExc);
    p.proj{proj}.bool_intensities = true(nRow,N);
    p.proj{proj}.emitter_is_on = true(nRow,N*nC);
    p.proj{proj}.intensities_crossCorr = nan(nRow,N*nC,nExc);
    p.proj{proj}.intensities_denoise = nan(nRow,N*nC,nExc);
    p.proj{proj}.intensities_DTA = nan(nRow,N*nC,nExc);
    if nFRET>0
        p.proj{proj}.FRET_DTA = nan(nRow,N*nFRET);
    end
    if nS>0
        p.proj{proj}.S_DTA = nan(nRow,N*nS);
    end
end
p.proj{proj}.intensities_bin(:,((m-1)*nC+1):m*nC,:) = I;
p.proj{proj}.resampling_time = splt;
p.proj{proj}.intensities_crossCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
